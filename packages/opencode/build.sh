TERMUX_PKG_HOMEPAGE=https://opencode.ai
TERMUX_PKG_DESCRIPTION="The open source AI coding agent"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
# opencode, opentui, opencode-pty, bun-pty; post_get_source fails if upstream pins differ.
TERMUX_PKG_VERSION=(
	"2.0.29"
	"0.5.17"
	"0.2.0"
	"0.4.11"
)

TERMUX_PKG_SRCURL=(
	"https://github.com/anomalyco/opencode/archive/refs/tags/v${TERMUX_PKG_VERSION[0]}.tar.gz"
	"https://github.com/anomalyco/opentui/archive/refs/tags/v${TERMUX_PKG_VERSION[1]}.tar.gz"
	"https://github.com/anomalyco/opencode-pty/archive/refs/tags/v${TERMUX_PKG_VERSION[2]}.tar.gz"
	"https://github.com/sursaone/bun-pty/archive/refs/tags/v${TERMUX_PKG_VERSION[3]}.tar.gz"
)
TERMUX_PKG_SHA256=(
	3d88f662bce9bee4b0af1cf7528f752039dceb4062811c5eae046649ce1dec2d
	f272f54f96ff230a188c9cf9f593105c6e784f0a14fdbcb7169e523d9c9b7a96
	7fc1d1ebf4b74cd1b2a83f059afa29a899990b85cf078e73b703004370a52754
	07ff88c9ee96019dd1691e9ede485e35221c036e599545075587cb85537157b2
)
TERMUX_PKG_AUTO_UPDATE=true

TERMUX_PKG_DEPENDS="bun, libc++, ripgrep"
TERMUX_PKG_RECOMMENDS="git"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HAS_DEBUG=false
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true

__check_pin() {
	local file="$1" pattern="$2" expected="$3" actual
	actual="$(grep -m1 -oP "$pattern" "$file")"
	[[ "$actual" == "$expected" ]] ||
		termux_error_exit "$file pins '$actual', build.sh has '$expected'"
}

__apply_diff() {
	local dir="$1" diff="$2"
	[[ -d "$dir" ]] || termux_error_exit "$dir not found"
	[[ -f "$dir/.termux-patched" ]] && return
	patch -p1 -d "$dir" -i "$TERMUX_PKG_BUILDER_DIR/$diff"
	touch "$dir/.termux-patched"
}

termux_step_post_get_source() {
	__check_pin package.json '^\s+"@opentui/core": "\K[0-9.]+' "${TERMUX_PKG_VERSION[1]}"
	__check_pin packages/cli/package.json '"@opencode-ai/pty": "\K[0-9.]+' "${TERMUX_PKG_VERSION[2]}"
	__check_pin packages/core/package.json '"bun-pty": "\K[0-9.]+' "${TERMUX_PKG_VERSION[3]}"

	__apply_diff "$TERMUX_PKG_SRCDIR/opentui-${TERMUX_PKG_VERSION[1]}" opentui-android-build.diff
	__apply_diff "$TERMUX_PKG_SRCDIR/opencode-pty-${TERMUX_PKG_VERSION[2]}" opencode-pty-android.diff
	__apply_diff "$TERMUX_PKG_SRCDIR/bun-pty-${TERMUX_PKG_VERSION[3]}" bun-pty-portable-pty-0.9.diff

	rm -f "$TERMUX_PKG_SRCDIR/opencode-pty-${TERMUX_PKG_VERSION[2]}/rust-toolchain.toml"
}

termux_step_pre_configure() {
	case "$TERMUX_ARCH" in
		aarch64) _ARCH=arm64; _PTY_LIB=librust_pty_arm64.so ;;
		x86_64)
			_ARCH=x64
			_PTY_LIB=librust_pty.so
			# x86_64 emits ELF TLS (__tls_get_addr, API 30+) in the Zig and Rust natives.
			TERMUX_PKG_UNDEF_SYMBOLS_FILES=$'./lib/opencode/libopentui-*.so\n./lib/opencode/opencode-pty-*'
			;;
		*) termux_error_exit "Unsupported architecture: $TERMUX_ARCH" ;;
	esac
	_INSTALL_DIR="$TERMUX_PREFIX/lib/opencode"
}

__build_libopentui() {
	termux_setup_zig

	local src="$TERMUX_PKG_SRCDIR/opentui-${TERMUX_PKG_VERSION[1]}/packages/native"
	local sysroot="$NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot"
	local inc="$TERMUX_PKG_TMPDIR/bionic-include"
	local crt="$sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL"
	local libc_file="$TERMUX_PKG_TMPDIR/android-libc.txt"
	local shim_head="#define _Nullable
#define _Nonnull
#ifndef __ANDROID_MIN_SDK_VERSION__
#define __ANDROID_MIN_SDK_VERSION__ $TERMUX_PKG_API_LEVEL
#endif"

	[[ -f "$crt/crtbegin_dynamic.o" ]] || termux_error_exit "No NDK crt files in $crt"

	rm -rf "$inc"
	mkdir -p "$inc/__opentui"
	cp -a "$sysroot/usr/include/." "$inc/"
	cp -a "$sysroot/usr/include/$TERMUX_HOST_PLATFORM/." "$inc/"
	cp "$src/src/vendor/miniaudio/miniaudio.h" "$inc/miniaudio.h"
	printf '%s\n#include "../miniaudio.h"\n' "$shim_head" > "$inc/__opentui/miniaudio_shimmed.h"
	printf '%s\n#include "../yoga/yoga/Yoga.h"\n' "$shim_head" > "$inc/__opentui/Yoga_shimmed.h"

	cd "$src"
	sh scripts/prepare-zig-deps.sh
	ln -sfn "$src/zig-deps/yoga" "$inc/yoga"

	cat > "$libc_file" <<-EOF
		include_dir=$inc
		sys_include_dir=$inc
		crt_dir=$crt
		msvc_lib_dir=
		kernel32_lib_dir=
		gcc_dir=
	EOF

	BIONIC_SYSROOT_INC="$inc" ANDROID_NDK_HOME="$NDK" \
		zig build --libc "$libc_file" \
		-Dlibrary-target="$TERMUX_HOST_PLATFORM.$TERMUX_PKG_API_LEVEL" \
		-Doptimize=ReleaseSafe

	_LIBOPENTUI="$(find "$src/lib" -name libopentui.so | head -n 1)"
	[[ -n "$_LIBOPENTUI" ]] || termux_error_exit "libopentui.so was not built"
}

__build_rust_natives() {
	termux_setup_zig
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	local pty="$TERMUX_PKG_SRCDIR/opencode-pty-${TERMUX_PKG_VERSION[2]}"
	local bun_pty="$TERMUX_PKG_SRCDIR/bun-pty-${TERMUX_PKG_VERSION[3]}/rust-pty"

	(
		export ANDROID_NDK_HOME="$NDK"
		cd "$pty"
		cargo build --release --target "$CARGO_TARGET_NAME"
		cd "$bun_pty"
		cargo build --release --target "$CARGO_TARGET_NAME"
	)

	_PTY_BIN="$pty/target/$CARGO_TARGET_NAME/release/opencode-pty"
	_RUST_PTY_LIB="$bun_pty/target/$CARGO_TARGET_NAME/release/librust_pty.so"
	[[ -f "$_PTY_BIN" ]] || termux_error_exit "opencode-pty was not built"
	[[ -f "$_RUST_PTY_LIB" ]] || termux_error_exit "librust_pty.so was not built"
}

# Replaces the glibc/musl binary shipped in node_modules with the Android build.
__swap_native() {
	local pattern="$1" replacement="$2" found
	found="$(find node_modules/.bun -path "$pattern" -type f)"
	[[ "$(printf '%s\n' "$found" | wc -l)" == 1 && -n "$found" ]] ||
		termux_error_exit "Expected exactly one match for $pattern, got: $found"
	cp -f "$replacement" "$found"
}

termux_step_make() {
	__build_libopentui
	__build_rust_natives

	cd "$TERMUX_PKG_SRCDIR"
	termux_setup_bun

	export OPENCODE_VERSION="${TERMUX_PKG_VERSION[0]}"
	export OPENCODE_CHANNEL="latest"
	export OPENCODE_INSTALL_DIR="$_INSTALL_DIR"

	bun install \
		--filter '@opencode/cli' --filter '@opencode/app' \
		--os='*' --cpu='*' --ignore-scripts

	__swap_native "*/@opentui/core-linux-${_ARCH}-musl/libopentui.so" "$_LIBOPENTUI"
	__swap_native "*/@opencode-ai/pty-linux-${_ARCH}-musl/bin/opencode-pty" "$_PTY_BIN"
	__swap_native "*/bun-pty/rust-pty/target/release/${_PTY_LIB}" "$_RUST_PTY_LIB"

	local chunk
	chunk="$(grep -rl 'function getCurrentNodeAssetTarget' node_modules/.bun/@opentui+core@*/node_modules/@opentui/core/chunk-bun-*.js)"
	[[ "$(printf '%s\n' "$chunk" | wc -l)" == 1 ]] || termux_error_exit "Unexpected opentui loader chunks: $chunk"
	patch -p1 "$chunk" -i "$TERMUX_PKG_BUILDER_DIR/opentui-loader-android.diff"

	cd packages/cli
	bun run script/build.ts --target="opencode-linux-${_ARCH}-android" --skip-install
}

termux_step_make_install() {
	local out="$TERMUX_PKG_SRCDIR/packages/cli/dist/cli-linux-${_ARCH}-android/lib"
	[[ -f "$out/index.js" ]] || termux_error_exit "Bundle not found in $out"

	rm -rf "$_INSTALL_DIR"
	install -d "$_INSTALL_DIR"
	cp -a "$out/." "$_INSTALL_DIR/"
	find "$_INSTALL_DIR" -type f -name 'opencode-pty*' -exec chmod 0755 {} +
	: > "$_INSTALL_DIR/bunfig.toml"

	# Empty bunfig and --no-env-file keep the project's bunfig/.env out of the CLI.
	cat > "$TERMUX_PREFIX/bin/opencode" <<-SCRIPT
		#!$TERMUX_PREFIX/bin/sh
		export OPENCODE_DISABLE_AUTOUPDATE=1
		export LD_LIBRARY_PATH="$TERMUX_PREFIX/lib\${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}"
		exec "$TERMUX_PREFIX/bin/bun" --smol --no-install --no-env-file --no-warnings \\
			--config="$_INSTALL_DIR/bunfig.toml" \\
			--user-agent="opencode/latest/${TERMUX_PKG_VERSION[0]}/cli" \\
			"$_INSTALL_DIR/index.js" "\$@"
	SCRIPT
	chmod 0755 "$TERMUX_PREFIX/bin/opencode"
}

TERMUX_PKG_HOMEPAGE=https://github.com/agavra/tuicr
TERMUX_PKG_DESCRIPTION="A code review TUI with vim keybindings, exports to GitHub, GitLab, Gitea, Bitbucket, or clipboard"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=0.25.0
TERMUX_PKG_SRCURL=https://github.com/agavra/tuicr/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e7553c629d89c3fae2845a21bddf365cc542e0d2f2eed01e2fb5ad7017bd81fc
TERMUX_PKG_DEPENDS="libgit2, libssh2, openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	# link against Termux's prebuilt libgit2/libssh2/openssl instead of
	# cross-compiling libgit2-sys/libssh2-sys/openssl-sys from vendored C source
	export OPENSSL_NO_VENDOR=1
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export LIBSSH2_SYS_USE_PKG_CONFIG=1
	termux_setup_rust

	# arboard has no backend for target_os = "android" and fails to compile
	# as-is, but its Linux/X11+Wayland backend works under Termux:X11.
	# Vendor arboard and neutralize the target_os = "android" exclusions so
	# that backend compiles against Android too. copy_text_to_clipboard()
	# already falls back to OSC 52 when Clipboard::new() fails, so this
	# degrades safely when Termux:X11 isn't installed/running.
	cargo vendor vendor >/dev/null
	find vendor -mindepth 1 -maxdepth 1 -type d ! -wholename vendor/arboard -exec rm -rf '{}' \;
	find vendor/arboard -type f -print0 | xargs -0 sed -i \
		-E 's/target_os[[:space:]]*=[[:space:]]*"android"/target_os = "disabled_for_termux_x11"/g'

	if grep -q '^\[patch\.crates-io\]' Cargo.toml; then
		sed -i '/^\[patch\.crates-io\]/a arboard = { path = "./vendor/arboard" }' Cargo.toml
	else
		{
			echo ""
			echo '[patch.crates-io]'
			echo 'arboard = { path = "./vendor/arboard" }'
		} >>Cargo.toml
	fi

	CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
	cargo fetch --target "$CARGO_TARGET_NAME"
	# libgit2-sys 0.18.8 only accepts libgit2 in ["1.9.7", "1.10.0") - fine
	# against Termux's current libgit2 (1.9.7) today, but this keeps the
	# build from breaking the moment either side's version drifts
	find "$CARGO_HOME/registry/src" -path '*/libgit2-sys-*/build.rs' \
		-exec sed -i -E 's/\.range_version\(([^)]*)\.\.[^)]*\)/.atleast_version(\1)/g' {} +
}

termux_step_make() {
	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release \
		--locked
}

termux_step_make_install() {
	install -Dm755 \
		"target/${CARGO_TARGET_NAME}/release/tuicr" \
		"${TERMUX_PREFIX}/bin/tuicr"
}

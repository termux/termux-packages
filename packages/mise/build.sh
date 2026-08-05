TERMUX_PKG_HOMEPAGE=https://mise.jdx.dev/
TERMUX_PKG_DESCRIPTION="dev tools, env vars, task runner"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.8.2"
TERMUX_PKG_SRCURL="https://github.com/jdx/mise/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=4c35c9f882d5672b7cd990ad3a4e5eb2607d67b720697e3ed7f56c93e0a91b05
TERMUX_PKG_DEPENDS="bzip2, openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=latest-release-tag

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_rust

	# Dummy CMake toolchain file to workaround build error:
	# error: failed to run custom build command for `libz-ng-sys v1.1.29`
	# ...
	# CMake Error at /home/builder/.termux-build/_cache/cmake-4.4.0/share/cmake-4.4/Modules/Platform/Android-Determine.cmake:217 (message):
	# Android: Neither the NDK or a standalone toolchain was found.
	export TARGET_CMAKE_TOOLCHAIN_FILE="${TERMUX_PKG_BUILDDIR}/android.toolchain.cmake"
	touch "${TERMUX_PKG_BUILDDIR}/android.toolchain.cmake"

	# Vendor cargo deps to ./vendor-termux/ - not ./vendor/ - because mise's
	# tree ships ./vendor/aqua-registry/ as build-time data (build.rs reads
	# vendor/aqua-registry/registry.yml). `cargo vendor` overwrites its
	# target directory, so pointing it at ./vendor/ deletes aqua-registry
	# and the build fails with `os error 2`.
	cargo vendor vendor-termux
	find ./vendor-termux \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor-termux/cc \
		! -wholename ./vendor-termux/sonic-rs \
		! -wholename ./vendor-termux/sonic-simd \
		-exec rm -rf '{}' \;

	local patch="$TERMUX_PKG_BUILDER_DIR/rust-cc-do-not-concatenate-all-the-CFLAGS.diff"
	local dir="vendor-termux/cc"
	echo "Applying patch: $patch"
	patch -p1 -d "$dir" < "$patch"

	patch="$TERMUX_PKG_BUILDER_DIR/sonic-simd-32-bit-x86.diff"
	dir="vendor-termux/sonic-simd"
	echo "Applying patch: $patch"
	patch -p1 -d "$dir" < "$patch"

	patch="$TERMUX_PKG_BUILDER_DIR/sonic-rs-32-bit-x86.diff"
	dir="vendor-termux/sonic-rs"
	echo "Applying patch: $patch"
	patch -p1 -d "$dir" < "$patch"

	cat <<-EOL >> Cargo.toml

		[patch.crates-io]
		cc = { path = "./vendor-termux/cc" }
		sonic-rs = { path = "./vendor-termux/sonic-rs" }
		sonic-simd = { path = "./vendor-termux/sonic-simd" }
	EOL

	local -u env_host="${CARGO_TARGET_NAME//-/_}"
	export CARGO_TARGET_"${env_host}"_RUSTFLAGS+=" -C link-arg=$(${CC} -print-libgcc-file-name)"

	# The `openssl-sys` crate fails to compile if we don't set this.
	# Declare and export separately, see http://shellcheck.net/wiki/SC2155
	HOST_TRIPLET="$(gcc -dumpmachine)"
	PKG_CONFIG_PATH_x86_64_unknown_linux_gnu="$(grep 'DefaultSearchPaths:' "/usr/share/pkgconfig/personality.d/${HOST_TRIPLET}.personality" | cut -d ' ' -f 2)"
	export PKG_CONFIG_PATH_x86_64_unknown_linux_gnu

	# This variable specifically **does not** use SHOUT_CASE naming like the CARGO_TARGET_* variable above.
	# The `sys-info` crate fails to compile if we don't set this.
	export CFLAGS_"${CARGO_TARGET_NAME//-/_}"+=" -Dindex=strchr"
}

termux_step_make() {
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release
}

termux_step_make_install() {
	# mise binary
	install -vDm755 "target/${CARGO_TARGET_NAME}/release/${TERMUX_PKG_NAME}" \
		-t "$TERMUX_PREFIX/bin"
	# man page
	install -vDm644 "man/man1/mise.1" \
		-t "${TERMUX_PREFIX}/share/man/man1"
	# shell completions
	install -vDm644 "completions/_${TERMUX_PKG_NAME}" \
		-t "${TERMUX_PREFIX}/share/zsh/site-functions"
	# The bash completion has a .bash extension which it shouldn't so fix that before installing it.
	mv -v "completions/${TERMUX_PKG_NAME}"{.bash,}
	install -vDm644 "completions/${TERMUX_PKG_NAME}" \
		-t "${TERMUX_PREFIX}/share/bash-completion/completions"
	install -vDm644 "completions/${TERMUX_PKG_NAME}.fish" \
		-t "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
}

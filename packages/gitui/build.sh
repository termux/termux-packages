TERMUX_PKG_HOMEPAGE=https://github.com/extrawurst/gitui
TERMUX_PKG_DESCRIPTION="Blazing fast terminal-ui for git written in rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.md"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.27.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/extrawurst/gitui/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=55a85f4a3ce97712b618575aa80f3c15ea4004d554e8899669910d7fb4ff6e4b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libgit2, libssh2, openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export OPENSSL_NO_VENDOR=1
	# export LIBGIT2_NO_VENDOR=1
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export LIBSSH2_SYS_USE_PKG_CONFIG=1

	termux_setup_cmake

	# Dummy CMake toolchain file to workaround build error:
	# error: failed to run custom build command for `libz-ng-sys v1.1.21`
	# ...
	# CMake Error at /home/builder/.termux-build/_cache/cmake-3.31.1/share/cmake-3.31/Modules/Platform/Android-Determine.cmake:218 (message):
	# Android: Neither the NDK or a standalone toolchain was found.
	export TARGET_CMAKE_TOOLCHAIN_FILE="${TERMUX_PKG_BUILDDIR}/android.toolchain.cmake"
	touch "${TERMUX_PKG_BUILDDIR}/android.toolchain.cmake"

	termux_setup_rust
	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	local f
	for f in $CARGO_HOME/registry/src/*/libgit2-sys-*/build.rs; do
		sed -i -E 's/\.range_version\(([^)]*)\.\.[^)]*\)/.atleast_version(\1)/g' "${f}"
	done
}

termux_step_make() {
	cargo build --release \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--locked
}

termux_step_make_install() {
	install -Dm700 target/"${CARGO_TARGET_NAME}"/release/gitui "$TERMUX_PREFIX"/bin/
}

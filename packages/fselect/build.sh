TERMUX_PKG_HOMEPAGE=https://fselect.rocks/
TERMUX_PKG_DESCRIPTION="Find files with SQL-like queries"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.6"
TERMUX_PKG_SRCURL=https://github.com/jhspetersson/fselect/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=4b7a6dc5f6f3da39c3242856a1c78734c7b14bd801dc4d7e32bc6f5a1809bc63
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

# ld.lld: error: undefined symbol: __aeabi_read_tp
TERMUX_PKG_BLACKLISTED_ARCHES="arm"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_rust

	# Dummy CMake toolchain file to workaround build error:
	# error: failed to run custom build command for `libz-ng-sys v1.1.15`
	# ...
	# CMake Error at /home/builder/.termux-build/_cache/cmake-3.28.3/share/cmake-3.28/Modules/Platform/Android-Determine.cmake:217 (message):
	# Android: Neither the NDK or a standalone toolchain was found.
	export TARGET_CMAKE_TOOLCHAIN_FILE="${TERMUX_PKG_BUILDDIR}/android.toolchain.cmake"
	touch "${TERMUX_PKG_BUILDDIR}/android.toolchain.cmake"
}

termux_step_post_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME"/release/fselect \
		"$TERMUX_PREFIX"/bin/fselect
}

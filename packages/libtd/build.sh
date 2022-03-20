TERMUX_PKG_HOMEPAGE=https://core.telegram.org/tdlib/
TERMUX_PKG_DESCRIPTION="Library for building Telegram clients."
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=1d15bafb5003cf36dbfdd4c839dbcc56368fb48e
TERMUX_PKG_VERSION="1.8.2-6529-g${_COMMIT:0:8}"
TERMUX_PKG_SRCURL="https://github.com/tdlib/td.git"
TERMUX_PKG_GIT_BRANCH=${_COMMIT}
TERMUX_PKG_DEPENDS="readline, openssl (>= 1.1.1), zlib"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
        termux_setup_cmake
        cmake "-DCMAKE_BUILD_TYPE=Release" "$TERMUX_PKG_SRCDIR"
        cmake --build . --target prepare_cross_compiling
}

termux_step_post_make_install() {
	# Fix rebuilds without ./clean.sh.
	rm -rf $TERMUX_PKG_HOSTBUILD_DIR
}

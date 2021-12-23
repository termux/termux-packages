TERMUX_PKG_HOMEPAGE=https://core.telegram.org/tdlib/
TERMUX_PKG_DESCRIPTION="Library for building Telegram clients"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.7.0
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/tdlib/td/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3daaf419f1738b7e0ac0e8a08f07e01a1faaf51175a59c0b113c15e30c69e173
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

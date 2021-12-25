TERMUX_PKG_HOMEPAGE=https://github.com/rkd77/elinks
TERMUX_PKG_DESCRIPTION="Full-Featured Text WWW Browser"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.15.0
TERMUX_PKG_SRCURL=https://github.com/rkd77/elinks/releases/download/v${TERMUX_PKG_VERSION}/elinks-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=bf2e9d752921f2d83a7dcac1062c37ae6c8d7c4057d8537abe1c42fbac946fb3
TERMUX_PKG_DEPENDS="libexpat, libiconv, libidn, openssl, libbz2, zlib"
TERMUX_PKG_AUTO_UPDATE=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-256-colors
--enable-true-color
--mandir=$TERMUX_PREFIX/share/man
--with-openssl
--without-brotli
--without-zstd
--without-gc
"

TERMUX_MAKE_PROCESSES=1

termux_step_pre_configure() {
    ./autogen.sh
}

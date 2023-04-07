TERMUX_PKG_HOMEPAGE=https://github.com/rkd77/elinks
TERMUX_PKG_DESCRIPTION="Full-Featured Text WWW Browser"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.16.0"
TERMUX_PKG_SRCURL=https://github.com/rkd77/elinks/releases/download/v${TERMUX_PKG_VERSION}/elinks-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4d65b78563af39ba1d0a9ab1c081e129ef2ed541009e6ff11c465ba9d8f0f234
TERMUX_PKG_DEPENDS="libexpat, libiconv, libidn, openssl, libbz2, zlib"
TERMUX_PKG_AUTO_UPDATE=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-256-colors
--enable-true-color
--mandir=$TERMUX_PREFIX/share/man
--with-openssl
--without-brotli
--without-zstd
"

TERMUX_MAKE_PROCESSES=1

termux_step_pre_configure() {
	./autogen.sh
}

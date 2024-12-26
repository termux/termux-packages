TERMUX_PKG_HOMEPAGE=https://github.com/rkd77/elinks
TERMUX_PKG_DESCRIPTION="Full-Featured Text WWW Browser"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.18.0"
TERMUX_PKG_SRCURL=https://github.com/rkd77/elinks/releases/download/v${TERMUX_PKG_VERSION}/elinks-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e56ef15996a1ca130789293ee6d49cbecf175c06266acfa676fa6edb271a1173
TERMUX_PKG_DEPENDS="libandroid-execinfo, libexpat, libiconv, libidn, openssl, libbz2, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-256-colors
--enable-true-color
--mandir=$TERMUX_PREFIX/share/man
--with-openssl
--without-brotli
--without-zstd
"

TERMUX_PKG_MAKE_PROCESSES=1

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-execinfo"
	./autogen.sh
}

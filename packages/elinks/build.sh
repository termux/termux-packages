TERMUX_PKG_HOMEPAGE=http://elinks.or.cz
TERMUX_PKG_DESCRIPTION="Full-Featured Text WWW Browser"
TERMUX_PKG_LICENSE="GPL-2.0"
_COMMIT=f86be659718c0cd0a67f88b42f07044c23d0d028
TERMUX_PKG_VERSION=0.13.GIT
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/xeffyr/elinks/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=3e65aaabcc4f6b2418643cf965786c00e3f196330f3e7863ca83f9e546d5e609
TERMUX_PKG_DEPENDS="libexpat, libidn, openssl, libbz2, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-256-colors
--enable-true-color
--mandir=$TERMUX_PREFIX/share/man
--with-openssl
--without-brotli
--without-gc
"
TERMUX_MAKE_PROCESSES=1

termux_step_pre_configure() {
    ./autogen.sh
}

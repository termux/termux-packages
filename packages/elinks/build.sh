TERMUX_PKG_HOMEPAGE=http://elinks.or.cz
TERMUX_PKG_DESCRIPTION="Full-Featured Text WWW Browser"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.13.GIT
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://dl.bintray.com/xeffyr/sources/elinks/elinks-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4e5000ee0d2fe3f18515946872d9c95123942c8a20e8a50cf24db2f17967cdf9
TERMUX_PKG_DEPENDS="libexpat, libiconv, libidn, openssl, libbz2, zlib"

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

TERMUX_PKG_HOMEPAGE=http://elinks.or.cz
TERMUX_PKG_DESCRIPTION="Full-Featured Text WWW Browser"
TERMUX_PKG_VERSION=0.12pre6
TERMUX_PKG_BUILD_REVISION=2
TERMUX_PKG_SRCURL=http://elinks.or.cz/download/elinks-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libexpat, libidn, openssl, libbz2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-256-colors --with-openssl --mandir=$TERMUX_PREFIX/share/man"

TERMUX_PKG_HOMEPAGE=http://links.twibright.com
TERMUX_PKG_DESCRIPTION="Web browser running in text mode"
TERMUX_PKG_VERSION=2.14
TERMUX_PKG_SRCURL=http://links.twibright.com/download/links-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libbz2, liblzma, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-gpm --without-x"
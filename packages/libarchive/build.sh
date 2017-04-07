TERMUX_PKG_HOMEPAGE=http://www.libarchive.org/
TERMUX_PKG_DESCRIPTION="Multi-format archive and compression library"
TERMUX_PKG_VERSION=3.3.1
TERMUX_PKG_SRCURL=http://www.libarchive.org/downloads/libarchive-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=29ca5bd1624ca5a007aa57e16080262ab4379dbf8797f5c52f7ea74a3b0424e7
TERMUX_PKG_DEPENDS="libbz2, liblzma, libxml2, openssl"

# --without-nettle to use openssl instead:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-nettle"

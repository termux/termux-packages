TERMUX_PKG_HOMEPAGE=http://www.libarchive.org/
TERMUX_PKG_DESCRIPTION="Multi-format archive and compression library"
TERMUX_PKG_VERSION=3.1.2
TERMUX_PKG_BUILD_REVISION=3
TERMUX_PKG_SRCURL=http://www.libarchive.org/downloads/libarchive-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="libbz2, liblzma, libxml2, openssl"

# --without-nettle to use openssl instead:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-nettle"

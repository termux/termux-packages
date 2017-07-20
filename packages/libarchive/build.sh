TERMUX_PKG_HOMEPAGE=https://www.libarchive.org/
TERMUX_PKG_DESCRIPTION="Multi-format archive and compression library"
TERMUX_PKG_VERSION=3.3.2
TERMUX_PKG_SHA256=ed2dbd6954792b2c054ccf8ec4b330a54b85904a80cef477a1c74643ddafa0ce
TERMUX_PKG_SRCURL=https://www.libarchive.org/downloads/libarchive-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libbz2, liblzma, libxml2, openssl"

# --without-nettle to use openssl instead:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-nettle"

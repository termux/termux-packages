TERMUX_PKG_HOMEPAGE=http://www.libarchive.org/
TERMUX_PKG_DESCRIPTION="Multi-format archive and compression library"
TERMUX_PKG_VERSION=3.2.2
TERMUX_PKG_SRCURL=http://www.libarchive.org/downloads/libarchive-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=691c194ee132d1f0f7a42541f091db811bc2e56f7107e9121be2bc8c04f1060f
TERMUX_PKG_DEPENDS="libbz2, liblzma, libxml2, openssl"

# --without-nettle to use openssl instead:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-nettle"

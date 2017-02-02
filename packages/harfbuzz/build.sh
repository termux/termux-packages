TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/HarfBuzz/
TERMUX_PKG_DESCRIPTION="OpenType text shaping engine"
TERMUX_PKG_VERSION=1.4.1
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_CHECKTYPE=SHA256
TERMUX_PKG_CHECKSUM=85a27fab639a1d651737dcb6b69e4101e3fd09522fdfdcb793df810b5cb315bd
TERMUX_PKG_DEPENDS="freetype,glib,libbz2,libpng"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-icu=no --disable-gtk-doc-html"

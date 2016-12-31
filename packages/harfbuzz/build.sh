TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/HarfBuzz/
TERMUX_PKG_DESCRIPTION="OpenType text shaping engine"
TERMUX_PKG_VERSION=1.3.4
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=718aa6fcadef1a6548315b8cfe42cc27e926256302c337f42df3a443843f6a2b
TERMUX_PKG_DEPENDS="freetype,glib,libbz2,libpng"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-icu=no --disable-gtk-doc-html"

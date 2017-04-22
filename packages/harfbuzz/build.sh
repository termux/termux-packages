TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/HarfBuzz/
TERMUX_PKG_DESCRIPTION="OpenType text shaping engine"
TERMUX_PKG_VERSION=1.4.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=d0e05438165884f21658154c709075feaf98c93ee5c694b951533ac425a9a711
TERMUX_PKG_DEPENDS="freetype,glib,libbz2,libpng,libgraphite"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-icu=yes --with-graphite2=yes --disable-gtk-doc-html"

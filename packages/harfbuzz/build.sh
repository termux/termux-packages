TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/HarfBuzz/
TERMUX_PKG_DESCRIPTION="OpenType text shaping engine"
TERMUX_PKG_VERSION=1.7.0
TERMUX_PKG_SHA256=042742d6ec67bc6719b69cf38a3fba24fbd120e207e3fdc18530dc730fb6a029
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="freetype,glib,libbz2,libpng,libgraphite"
TERMUX_PKG_BUILD_DEPENDS="libicu"
TERMUX_PKG_DEVPACKAGE_DEPENDS="libgraphite-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-icu=yes --with-graphite2=yes --disable-gtk-doc-html"

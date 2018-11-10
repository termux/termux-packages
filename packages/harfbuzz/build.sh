TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/HarfBuzz/
TERMUX_PKG_DESCRIPTION="OpenType text shaping engine"
TERMUX_PKG_VERSION=2.0.2
TERMUX_PKG_SHA256=f6de6c9dc89a56909227ac3e3dc9b18924a0837936ffd9633d13e981bcbd96e0
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="freetype,glib,libbz2,libpng,libgraphite"
TERMUX_PKG_BUILD_DEPENDS="libicu"
TERMUX_PKG_DEVPACKAGE_DEPENDS="libgraphite-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-icu=yes --with-graphite2=yes --disable-gtk-doc-html"

TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/HarfBuzz/
TERMUX_PKG_DESCRIPTION="OpenType text shaping engine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.5.2
TERMUX_PKG_SHA256=7c8fcf9a2bbe3df5ed9650060d89f9b7cfd40ec5729671447ace8b0505527e8b
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="freetype, glib, libbz2, libc++, libpng, libgraphite"
TERMUX_PKG_BUILD_DEPENDS="libicu"
TERMUX_PKG_DEVPACKAGE_DEPENDS="libgraphite-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-icu=yes --with-graphite2=yes --disable-gtk-doc-html"

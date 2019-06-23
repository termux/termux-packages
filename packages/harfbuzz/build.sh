TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/HarfBuzz/
TERMUX_PKG_DESCRIPTION="OpenType text shaping engine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.5.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6d4834579abd5f7ab3861c085b4c55129f78b27fe47961fd96769d3704f6719e
TERMUX_PKG_DEPENDS="freetype, glib, libbz2, libc++, libpng, libgraphite"
TERMUX_PKG_BUILD_DEPENDS="libicu"
TERMUX_PKG_DEVPACKAGE_DEPENDS="libgraphite-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-icu=yes --with-graphite2=yes --disable-gtk-doc-html"

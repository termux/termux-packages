TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/HarfBuzz/
TERMUX_PKG_DESCRIPTION="OpenType text shaping engine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.6.7
TERMUX_PKG_SRCURL=https://github.com/harfbuzz/harfbuzz/releases/download/${TERMUX_PKG_VERSION}/harfbuzz-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=49e481d06cdff97bf68d99fa26bdf785331f411614485d892ea4c78eb479b218
TERMUX_PKG_DEPENDS="freetype, glib, libbz2, libc++, libpng, libgraphite"
TERMUX_PKG_BREAKS="harfbuzz-dev"
TERMUX_PKG_REPLACES="harfbuzz-dev"
TERMUX_PKG_BUILD_DEPENDS="libicu"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-icu=yes --with-graphite2=yes --disable-gtk-doc-html"

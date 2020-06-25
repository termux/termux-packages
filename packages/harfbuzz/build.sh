TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/HarfBuzz/
TERMUX_PKG_DESCRIPTION="OpenType text shaping engine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.6.8
TERMUX_PKG_SRCURL=https://github.com/harfbuzz/harfbuzz/releases/download/${TERMUX_PKG_VERSION}/harfbuzz-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6648a571a27f186e47094121f0095e1b809e918b3037c630c7f38ffad86e3035
TERMUX_PKG_DEPENDS="freetype, glib, libbz2, libc++, libpng, libgraphite"
TERMUX_PKG_BREAKS="harfbuzz-dev"
TERMUX_PKG_REPLACES="harfbuzz-dev"
TERMUX_PKG_BUILD_DEPENDS="libicu"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-icu=yes --with-graphite2=yes --disable-gtk-doc-html"

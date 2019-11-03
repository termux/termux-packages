TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/HarfBuzz/
TERMUX_PKG_DESCRIPTION="OpenType text shaping engine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.6.4
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/harfbuzz-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=9413b8d96132d699687ef914ebb8c50440efc87b3f775d25856d7ec347c03c12
TERMUX_PKG_DEPENDS="freetype, glib, libbz2, libc++, libpng, libgraphite"
TERMUX_PKG_BREAKS="harfbuzz-dev"
TERMUX_PKG_REPLACES="harfbuzz-dev"
TERMUX_PKG_BUILD_DEPENDS="libicu"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-icu=yes --with-graphite2=yes --disable-gtk-doc-html"

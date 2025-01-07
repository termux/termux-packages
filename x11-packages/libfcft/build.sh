TERMUX_PKG_HOMEPAGE=https://codeberg.org/dnkl/fcft
TERMUX_PKG_DESCRIPTION="A small font loading and glyph rasterization library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.1.9"
TERMUX_PKG_SRCURL=https://codeberg.org/dnkl/fcft/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4b7e3b2ab7e14f532d8a9cb0f2d3b0cdf9d2919b95e6ab8030f7ac87d059c2b6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fontconfig, freetype, harfbuzz, libpixman, utf8proc"
TERMUX_PKG_BUILD_DEPENDS="libtllist, scdoc"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddocs=enabled
"

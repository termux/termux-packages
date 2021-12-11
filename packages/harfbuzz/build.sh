TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/HarfBuzz/
TERMUX_PKG_DESCRIPTION="OpenType text shaping engine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/harfbuzz/harfbuzz/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c27d2640e70e95bdbc2fbeca2f9cc212ee583da1149c9f6dacf1316217652e56
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, glib, libbz2, libc++, libpng, libgraphite"
TERMUX_PKG_BREAKS="harfbuzz-dev"
TERMUX_PKG_REPLACES="harfbuzz-dev"
TERMUX_PKG_BUILD_DEPENDS="libicu"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dgraphite=enabled"

termux_step_post_get_source() {
	mv CMakeLists.txt CMakeLists.txt.unused
}

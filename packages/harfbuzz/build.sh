TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/HarfBuzz/
TERMUX_PKG_DESCRIPTION="OpenType text shaping engine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.0.1
TERMUX_PKG_SRCURL=https://github.com/harfbuzz/harfbuzz/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9f6601010fc471b8a41f56d529b6000bd3a6df3dca10565794669fa66292457c
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="freetype, glib, libcairo, libgraphite"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_BREAKS="harfbuzz-dev"
TERMUX_PKG_REPLACES="harfbuzz-dev"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgobject=enabled
-Dgraphite=enabled
-Dintrospection=enabled
"
TERMUX_PKG_RM_AFTER_INSTALL="
share/gtk-doc
"

termux_step_post_get_source() {
	mv CMakeLists.txt CMakeLists.txt.unused
}

termux_step_pre_configure() {
	termux_setup_gir
}

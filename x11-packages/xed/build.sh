TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/xed
TERMUX_PKG_DESCRIPTION="A small and lightweight text editor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.9.0"
TERMUX_PKG_SRCURL="https://github.com/linuxmint/xed/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=8c1e685b8506eda2bdae022382f73ae1217a1e1549277f8482b58a2cdb7f5033
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+(?!-)"
TERMUX_PKG_DEPENDS="glib, gtk3, libpng, zlib, xapp, pango, at-spi2-core, libxml2, pygobject, libpeas, libcairo, libx11, gtksourceview4, gspell, dconf"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, intltool, gobject-introspection"
TERMUX_PKG_PYTHON_COMMON_DEPS="itstool"
TERMUX_PKG_VERSIONED_GIR=false

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}

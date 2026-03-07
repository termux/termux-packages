TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/nemo
TERMUX_PKG_DESCRIPTION="Cinnamon File manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.4"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/linuxmint/nemo/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=258807feb2e7bac523707d6b3daf2d9439e7135123cbe795183d5aaa6fd691ed
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="glib, gtk3, gobject-introspection, pygobject, json-glib, cinnamon-desktop, libx11, xapp, libexif, pango, libgsf, dbus-python, libcairo, gvfs, libheif-progs, tinysparql"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dxmp=false
-Dgtk_doc=false
-Dselinux=false
-Dtracker=true
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}

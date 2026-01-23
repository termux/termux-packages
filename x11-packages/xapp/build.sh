TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/xapp
TERMUX_PKG_DESCRIPTION="Cross-desktop libraries and common resources "
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.2"
TERMUX_PKG_SRCURL="https://github.com/linuxmint/xapp/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d0ea664053e6f35cc556e060b161905004f03d0695473772d2fb8a37cf445591
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="glib, dbus, gigolo, gtk3, gdk-pixbuf, libcairo, libx11, libgnomekbd, pygobject, gobject-introspection, libdbusmenu, libdbusmenu-gtk3, xapp-symbolic-icons"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddocs=false
-Dpy-overrides-dir=$TERMUX_PYTHON_HOME/site-packages/gi/overrides
-Dintrospection=true
-Dvapi=true
-Dxfce=false
-Dmate=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}

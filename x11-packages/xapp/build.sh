TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/xapp
TERMUX_PKG_DESCRIPTION="Cross-desktop libraries and common resources "
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.4.0"
TERMUX_PKG_SRCURL="https://github.com/linuxmint/xapp/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=eccba6c93ec4143ebfb3d3575f8053f2f05ba865f31bf9f250d171d938b2373c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="^\d+\.\d+\.\d+$"
TERMUX_PKG_DEPENDS="glib, dbus, gigolo, gtk3, gdk-pixbuf, libcairo, libx11, libgnomekbd, pygobject, gobject-introspection, libdbusmenu, libdbusmenu-gtk3, xapp-symbolic-icons"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac, libwayland-cross-scanner"
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
	termux_setup_pkg_config_wrapper "${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig:${TERMUX_PREFIX}/opt/libwayland/cross/lib/x86_64-linux-gnu/pkgconfig"

	export TERMUX_MESON_ENABLE_SOVERSION=1
}

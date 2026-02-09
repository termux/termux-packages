TERMUX_PKG_HOMEPAGE=https://github.com/zquestz/plank-reloaded
TERMUX_PKG_DESCRIPTION="Fork of the original Plank project, providing a simple dock for X11 desktop environments"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.164"
TERMUX_PKG_SRCURL="https://github.com/zquestz/plank-reloaded/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=7647164a41f1eada95606e36dd0fd988640c4d656e3d9b45601081b8f768cfe9
TERMUX_PKG_DEPENDS="atk, bamf, libcairo, gdk-pixbuf, glib, gnome-menus, gtk3, libgee, libwnck, libx11, libxfixes, libxi, pango, libdbusmenu-gtk3"
TERMUX_PKG_BUILD_DEPENDS="gnome-common, intltool, valac"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denable-apport=false
-Dproduction-release=true
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}

TERMUX_PKG_HOMEPAGE=https://github.com/zquestz/plank-reloaded
TERMUX_PKG_DESCRIPTION="Fork of the original Plank project, providing a simple dock for X11 desktop environments"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.163"
TERMUX_PKG_SRCURL=https://github.com/zquestz/plank-reloaded/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d7c1e6fe427c97a8793849385875db9670104c84858ccff763e9dbb58f7a5535
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

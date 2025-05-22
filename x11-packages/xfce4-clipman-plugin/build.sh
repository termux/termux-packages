TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-clipman-plugin/start
TERMUX_PKG_DESCRIPTION="Clipman is a clipboard manager for Xfce"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.0"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-clipman-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-clipman-plugin-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=903302c3070a951d44ee17a84fa3cf21d36c6787678af8fbfc79e469fd00cb46
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gdk-pixbuf, gtk3, libcairo, libqrencode, libwayland, libx11, libxfce4ui, libxfce4util, libxtst, xfce4-panel, xfconf"
TERMUX_PKG_BUILD_DEPENDS="glib-cross, libwayland-protocols, libwayland-cross-scanner"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dqrencode=enabled
-Dtests=false
-Dwayland=enabled
-Dx11=enabled
-Dxtst=enabled
"

termux_step_pre_configure() {
	termux_setup_pkg_config_wrapper \
	"${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig:${TERMUX_PREFIX}/opt/libwayland/cross/lib/x86_64-linux-gnu/pkgconfig"
}

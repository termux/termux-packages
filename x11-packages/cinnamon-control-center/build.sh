TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/cinnamon-control-center
TERMUX_PKG_DESCRIPTION="Cinnamon control center"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.8.1"
TERMUX_PKG_SRCURL="https://github.com/linuxmint/cinnamon-control-center/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=c58c03a4de6102946ba97a54140f9cf20b909f9e3ca70d515d0d41de931bb705
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+(?!-)"
TERMUX_PKG_DEPENDS="glib, gtk3, libgnomekbd, libnotify, libx11, libxklavier, python-pip, upower, cinnamon-desktop, cinnamon-menus, cinnamon-settings-daemon"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_PYTHON_TARGET_DEPS="setproctitle"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dcolor=false
-Dmodemmanager=false
-Dnetworkmanager=false
-Donlineaccounts=false
-Dwacom=false
-Dpolkit=false
-Dudev=false
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}

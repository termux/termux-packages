TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/cinnamon-control-center
TERMUX_PKG_DESCRIPTION="Cinnamon control center"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.4.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/linuxmint/cinnamon-control-center/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a68886524ce3f18952bc79d28061b71fc48a24e5dac5175874e3d390425bad92
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="glib, gtk3, libgnomekbd, libnotify, libx11, libxklavier, upower, cinnamon-desktop, cinnamon-menus, cinnamon-settings-daemon"
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

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install $TERMUX_PKG_PYTHON_TARGET_DEPS
	EOF
}

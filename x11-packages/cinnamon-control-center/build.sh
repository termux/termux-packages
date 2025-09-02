TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/cinnamon-control-center
TERMUX_PKG_DESCRIPTION="Cinnamon control center"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="master.lmde6"
TERMUX_PKG_SRCURL="https://github.com/linuxmint/cinnamon-control-center/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=c8db6b991f1b78e75f60041df7031fd2e5d5ea7040f4ae7f160dec75b320ee91
TERMUX_PKG_AUTO_UPDATE=true
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

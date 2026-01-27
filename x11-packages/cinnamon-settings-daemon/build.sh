TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/cinnamon-settings-daemon
TERMUX_PKG_DESCRIPTION="The settings daemon for the Cinnamon desktop"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.3"
TERMUX_PKG_SRCURL="https://github.com/linuxmint/cinnamon-settings-daemon/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=c55cd5037adeb05a25c21fd4a9c03bd147e2917727c189a58e79c9dbfcaf489c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="glib, cinnamon-desktop, libcanberra, libcolord, fontconfig, libgnomekbd, gtk3, libnotify, pango, libxfixes, pulseaudio-glib, upower, libx11, libxklavier, littlecms"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddbus_service_dir="$TERMUX_PREFIX/share/dbus-1/system-services/"
-Ddbus_system_dir="$TERMUX_PREFIX/share/dbus-1/system.d/"
-Duse_polkit=disabled
-Duse_logind=disabled
-Duse_gudev=disabled
-Duse_cups=disabled
-Duse_smartcard=disabled
-Duse_wacom=disabled
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}

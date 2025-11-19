TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/cinnamon-settings-daemon
TERMUX_PKG_DESCRIPTION="The settings daemon for the Cinnamon desktop "
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.4.3"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/linuxmint/cinnamon-settings-daemon/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e7acab8453d084dbc97347145be287a65fc513b1a5629d16587be60367a97fdd
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

termux_pkg_auto_update() {
	local latest_release
	latest_release="$(git ls-remote --tags "$TERMUX_PKG_HOMEPAGE.git" \
		| grep -oP "refs/tags/\K${TERMUX_PKG_UPDATE_VERSION_REGEXP}$" \
		| sort -V \
		| tail -n1)"

	if [[ "${latest_release}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	termux_pkg_upgrade_version "${latest_release}"
}

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}

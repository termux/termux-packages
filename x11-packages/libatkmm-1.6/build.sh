TERMUX_PKG_HOMEPAGE=https://www.gtkmm.org/
TERMUX_PKG_DESCRIPTION="The C++ binding for the ATK library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.28.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/atkmm/${TERMUX_PKG_VERSION%.*}/atkmm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0a142a8128f83c001efb8014ee463e9a766054ef84686af953135e04d28fdab3
TERMUX_PKG_DEPENDS="atk, glib, libc++, libglibmm-2.4, libsigc++-2.0"
TERMUX_PKG_AUTO_UPDATE=true

termux_pkg_auto_update() {
	local series="${TERMUX_PKG_VERSION%.*}"
	local latest_version
	latest_version="$(curl --silent "https://download.gnome.org/sources/atkmm/${series}/" | \
		grep -oP "atkmm-\K${series//./\\.}\.[0-9]+(?=\.tar\.xz)" | sort -V | tail -n1)"

	if [[ -z "${latest_version}" ]]; then
		echo "WARN: Unable to get the latest version." >&2
		return
	fi

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}

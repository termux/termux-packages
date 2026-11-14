TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gcal/
TERMUX_PKG_DESCRIPTION="Program for calculating and printing calendars"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.2.0
TERMUX_PKG_SRCURL=https://www.alteholz.dev/gnu/gcal-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d8bd2d7411e78251d67064aa0f1ca60a523bf856ee3e6d89d07d85a1233478dc
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-threads
ac_cv_header_spawn_h=no
ac_cv_func_strerror_r_char_p=no
CHECK_CFLAGS=-DUNUSED
CHECK_LIBS=-DUNUSED
"

termux_pkg_auto_update() {
	local latest_version
	latest_version="$(curl --silent https://www.alteholz.dev/gnu/ | grep -oP 'gcal-\K[0-9]+(\.[0-9]+)+(?=\.tar\.xz)' | sort -V | tail -n1)"

	if [[ -z "${latest_version}" ]]; then
		echo "WARN: Unable to get the latest version." >&2
		return
	fi

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_pre_configure() {
	sed -i '/^\ttests \\$/d' Makefile.am
	autoreconf -fi
}

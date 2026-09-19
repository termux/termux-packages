TERMUX_PKG_HOMEPAGE=https://www.gtkmm.org/
TERMUX_PKG_DESCRIPTION="A C++ API for parts of glib that are useful for C++"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.66.10"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/glibmm/${TERMUX_PKG_VERSION%.*}/glibmm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2b61780203aed98e701d3ea57c8f353e7c8ada9706a79be782f6c5153dd035c0
TERMUX_PKG_DEPENDS="glib, libc++, libsigc++-2.0"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbuild-examples=false
"

termux_step_post_get_source() {
	local _hdr _cname
	for _hdr in \
		"${TERMUX_PKG_SRCDIR}/untracked/gio/giomm/dbusactiongroup.h:GDBusActionGroup" \
		"${TERMUX_PKG_SRCDIR}/untracked/gio/giomm/emblem.h:GEmblem" \
	; do
		_cname="${_hdr##*:}"
		_hdr="${_hdr%%:*}"
		if [ ! -e "${_hdr}" ]; then
			termux_error_exit "file ${_hdr} not found."
		fi
		sed -i -E "s|^using ${_cname}Class = struct _${_cname}Class;\$|#include <gio/gio.h>|" "${_hdr}"
	done
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}

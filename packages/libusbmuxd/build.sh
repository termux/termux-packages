TERMUX_PKG_HOMEPAGE=https://libimobiledevice.org
TERMUX_PKG_DESCRIPTION="A client library for applications to handle usbmux protocol connections with iOS devices"
TERMUX_PKG_LICENSE="LGPL-2.1, GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.1"
TERMUX_PKG_SRCURL=https://github.com/libimobiledevice/libusbmuxd/releases/download/${TERMUX_PKG_VERSION}/libusbmuxd-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=5546f1aba1c3d1812c2b47d976312d00547d1044b84b6a461323c621f396efce
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libimobiledevice-glue, libplist"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-preflight
--without-systemd
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=7

	local e=$(sed -En 's/LIBUSBMUXD_SO_VERSION="?([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
				configure.ac)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="lib/libusbmuxd-2.0.so"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}

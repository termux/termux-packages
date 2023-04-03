TERMUX_PKG_HOMEPAGE=https://libimobiledevice.org
TERMUX_PKG_DESCRIPTION="A client library for applications to handle usbmux protocol connections with iOS devices"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.2
TERMUX_PKG_SRCURL=https://github.com/libimobiledevice/libusbmuxd/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8ae3e1d9340177f8f3a785be276435869363de79f491d05d8a84a59efc8a8fdc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libusb, libplist, usbmuxd"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=6

	local e=$(sed -En 's/LIBUSBMUXD_SO_VERSION="?([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
				configure.ac)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_configure() {
	./autogen.sh \
		--prefix=$TERMUX_PREFIX \
		--without-preflight \
		--without-systemd \
		--host=$TERMUX_HOST_PLATFORM
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

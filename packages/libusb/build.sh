TERMUX_PKG_HOMEPAGE=https://libusb.info/
TERMUX_PKG_DESCRIPTION="A C library that provides generic access to USB devices"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.29"
TERMUX_PKG_SRCURL=https://github.com/libusb/libusb/releases/download/v${TERMUX_PKG_VERSION}/libusb-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=5977fc950f8d1395ccea9bd48c06b3f808fd3c2c961b44b0c2e6e29fc3a70a85
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libusb-dev"
TERMUX_PKG_REPLACES="libusb-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-udev"

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="lib/libusb-1.0.so"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}

TERMUX_PKG_HOMEPAGE=https://libusb.info/
TERMUX_PKG_DESCRIPTION="A C library that provides generic access to USB devices"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_VERSION=1.0.22
TERMUX_PKG_SRCURL=https://github.com/libusb/libusb/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3500f7b182750cd9ccf9be8b1df998f83df56a39ab264976bdb3307773e16f48
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-udev"

termux_step_pre_configure() {
	NOCONFIGURE=true ./autogen.sh
}

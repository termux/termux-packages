TERMUX_PKG_HOMEPAGE=http://libusb.info/
TERMUX_PKG_DESCRIPTION="A cross-platform user library to access USB devices"
TERMUX_PKG_VERSION=1.0.21
TERMUX_PKG_SRCURL=https://github.com/libusb/libusb/archive/v${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=83895453d7b6e8149ba3c2aaac796615a80a6a599a94458e73029fef12d1721c
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-udev"

termux_step_pre_configure() {
	cd ${TERMUX_PKG_SRCDIR}
	NOCONFIGURE=true ./autogen.sh
}

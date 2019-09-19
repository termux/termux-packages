TERMUX_PKG_HOMEPAGE=https://libusb.info/
TERMUX_PKG_DESCRIPTION="A C library that provides generic access to USB devices"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_VERSION=1.0.23
TERMUX_PKG_SRCURL=https://github.com/libusb/libusb/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=02620708c4eea7e736240a623b0b156650c39bfa93a14bcfa5f3e05270313eba
TERMUX_PKG_BREAKS="libusb-dev"
TERMUX_PKG_REPLACES="libusb-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-udev"

termux_step_pre_configure() {
	NOCONFIGURE=true ./autogen.sh
}

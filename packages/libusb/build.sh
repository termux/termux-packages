TERMUX_PKG_HOMEPAGE=https://libusb.info/
TERMUX_PKG_DESCRIPTION="A C library that provides generic access to USB devices"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.25
TERMUX_PKG_SRCURL=https://github.com/libusb/libusb/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f9c4b7dad27a6196ca9ec3c6ec7fa446194342de326c71e030eb2c480895e169
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libusb-dev"
TERMUX_PKG_REPLACES="libusb-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-udev"

termux_step_pre_configure() {
	NOCONFIGURE=true ./autogen.sh
}

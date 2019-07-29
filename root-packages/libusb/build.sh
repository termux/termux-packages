TERMUX_PKG_HOMEPAGE=https://libusb.info/
TERMUX_PKG_DESCRIPTION="A C library that provides generic access to USB devices"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_VERSION=1.0.23-rc1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/libusb/libusb/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e8b42af53a54488286bf164266766c9ca7fb692773fe7b47ea0ccca4d6fbf4a0
TERMUX_PKG_BREAKS="libusb-dev"
TERMUX_PKG_REPLACES="libusb-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-udev"

termux_step_pre_configure() {
	NOCONFIGURE=true ./autogen.sh
}

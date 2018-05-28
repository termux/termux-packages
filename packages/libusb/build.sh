TERMUX_PKG_HOMEPAGE=http://libusb.info
TERMUX_PKG_DESCRIPTION="A cross-platform user library to access USB devices "
TERMUX_PKG_VERSION=1.0.21
TERMUX_PKG_SRCURL=https://github.com/libusb/libusb/releases/download/v${TERMUX_PKG_VERSION}/libusb-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=7dce9cce9a81194b7065ee912bcd55eeffebab694ea403ffb91b67db66b1824b
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-udev" 

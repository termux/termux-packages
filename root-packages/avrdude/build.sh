TERMUX_PKG_HOMEPAGE=https://avrdudes.github.io/avrdude/
TERMUX_PKG_DESCRIPTION="Software for programming Microchip (former Atmel) AVR Microcontrollers"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.2"
TERMUX_PKG_SRCURL=https://github.com/avrdudes/avrdude/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=72fbe49d3e3ea2f48a750e7f2c16287b163a580e020f745af39d45ba68d9d6ae
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libusb"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"

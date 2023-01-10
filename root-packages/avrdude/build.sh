TERMUX_PKG_HOMEPAGE=https://avrdudes.github.io/avrdude/
TERMUX_PKG_DESCRIPTION="Software for programming Microchip (former Atmel) AVR Microcontrollers"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.1
TERMUX_PKG_SRCURL=https://github.com/avrdudes/avrdude/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=016a5c95746fadc169cfb3009f6aa306ccdea2ff279fdb6fddcbe7526d84e5eb
TERMUX_PKG_DEPENDS="libusb"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"

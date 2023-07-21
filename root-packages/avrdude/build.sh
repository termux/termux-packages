TERMUX_PKG_HOMEPAGE=https://avrdudes.github.io/avrdude/
TERMUX_PKG_DESCRIPTION="Software for programming Microchip (former Atmel) AVR Microcontrollers"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.2
TERMUX_PKG_SRCURL=https://github.com/avrdudes/avrdude/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=beb4e0b0a07f8d47e550329ab93c345d5252350de6f833afde51b4d8bd934674
TERMUX_PKG_DEPENDS="libusb"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"

TERMUX_PKG_HOMEPAGE=https://avrdudes.github.io/avrdude/
TERMUX_PKG_DESCRIPTION="Software for programming Microchip (former Atmel) AVR Microcontrollers"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.3
TERMUX_PKG_SRCURL=https://github.com/avrdudes/avrdude/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1c61ae67aacf8b8ccae5741f987ba4b0c48d6e320405520352a8eca8c6e2c457
TERMUX_PKG_DEPENDS="libusb"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"

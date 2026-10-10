TERMUX_PKG_HOMEPAGE=https://avrdudes.github.io/avrdude/
TERMUX_PKG_DESCRIPTION="Software for programming Microchip (former Atmel) AVR Microcontrollers"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.3"
TERMUX_PKG_SRCURL=https://github.com/avrdudes/avrdude/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6c6fe3606f2ef331e502fb9c1d418ba09eb9705e811efbe18259025a9787ee3d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libusb"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"

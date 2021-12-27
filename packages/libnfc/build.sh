TERMUX_PKG_HOMEPAGE=https://github.com/nfc-tools/libnfc
TERMUX_PKG_DESCRIPTION="Free/Libre Near Field Communication (NFC) library"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.8.0
TERMUX_PKG_SRCURL=https://github.com/nfc-tools/libnfc/releases/download/libnfc-${TERMUX_PKG_VERSION}/libnfc-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=6d9ad31c86408711f0a60f05b1933101c7497683c2e0d8917d1611a3feba3dd5
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-drivers=acr122s,arygon,pn532_uart,pn532_spi,pn532_i2c
"

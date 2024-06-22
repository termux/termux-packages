TERMUX_PKG_HOMEPAGE=https://ccid.apdu.fr/
TERMUX_PKG_DESCRIPTION="A generic USB CCID (Chip/Smart Card Interface Devices) driver and ICCD (Integrated Circuit(s) Card Devices)."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.4
TERMUX_PKG_SRCURL=https://ccid.apdu.fr/files/ccid-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=6e832adc172ecdcfdee2b56f33144684882cbe972daff1938e7a9c73a64f88bf
TERMUX_PKG_DEPENDS="libusb, pcscd"
TERMUX_PKG_BUILD_DEPENDS="libpcsclite, flex"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
"

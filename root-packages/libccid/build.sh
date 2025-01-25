TERMUX_PKG_HOMEPAGE=https://ccid.apdu.fr/
TERMUX_PKG_DESCRIPTION="A generic USB CCID (Chip/Smart Card Interface Devices) driver and ICCD (Integrated Circuit(s) Card Devices)."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_SRCURL=https://ccid.apdu.fr/files/ccid-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2eca8fb07e8fe7c0d39daeaca7b97cd73c40ed9b72738a24ad3dcbdfc918e1ea
TERMUX_PKG_DEPENDS="libusb, pcscd"
TERMUX_PKG_BUILD_DEPENDS="libpcsclite, flex"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
"

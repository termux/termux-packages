TERMUX_PKG_HOMEPAGE=https://ccid.apdu.fr/
TERMUX_PKG_DESCRIPTION="A generic USB CCID (Chip/Smart Card Interface Devices) driver and ICCD (Integrated Circuit(s) Card Devices)."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.2
TERMUX_PKG_SRCURL=https://github.com/LudovicRousseau/CCID/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6d5e6a6884090831ed155ee75cbc03aed252bd8158d94f507a94f05ebaba296c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libusb, pcscd"
TERMUX_PKG_BUILD_DEPENDS="libpcsclite, flex"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
"

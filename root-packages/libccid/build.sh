TERMUX_PKG_HOMEPAGE=https://ccid.apdu.fr/
TERMUX_PKG_DESCRIPTION="A generic USB CCID (Chip/Smart Card Interface Devices) driver and ICCD (Integrated Circuit(s) Card Devices)."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.0"
TERMUX_PKG_SRCURL=https://github.com/LudovicRousseau/CCID/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4abe76010a72944e02e8d5d4d60ba665f941891eee2a35f77fd35cebc095e14b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libusb, pcscd"
TERMUX_PKG_BUILD_DEPENDS="libpcsclite, flex"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dudev-rules=false
"

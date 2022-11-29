TERMUX_PKG_HOMEPAGE=https://ccid.apdu.fr/
TERMUX_PKG_DESCRIPTION="A generic USB CCID (Chip/Smart Card Interface Devices) driver and ICCD (Integrated Circuit(s) Card Devices)."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.1
TERMUX_PKG_SRCURL=https://ccid.apdu.fr/files/ccid-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=e7a78c398ec0d617a4f98bac70d5b64f78689284dd0ae87d4692e2857f117377
TERMUX_PKG_DEPENDS="libusb, pcscd"
TERMUX_PKG_BUILD_DEPENDS="libpcsclite"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_prog_LEX=:
"

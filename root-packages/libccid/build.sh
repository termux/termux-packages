TERMUX_PKG_HOMEPAGE=https://ccid.apdu.fr/
TERMUX_PKG_DESCRIPTION="A generic USB CCID (Chip/Smart Card Interface Devices) driver and ICCD (Integrated Circuit(s) Card Devices)."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.31
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://ccid.apdu.fr/files/ccid-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=6b48d7b6e4390e038d25630f8664fe81618ab00f232d6efbe0e3cc6df28ce8f7
TERMUX_PKG_DEPENDS="libpcsclite, libusb, flex"

termux_step_pre_configure() {
	export LEXLIB=$TERMUX_PREFIX/lib/libfl.so
}

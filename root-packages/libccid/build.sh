TERMUX_PKG_HOMEPAGE=https://ccid.apdu.fr/
TERMUX_PKG_DESCRIPTION="A generic USB CCID (Chip/Smart Card Interface Devices) driver and ICCD (Integrated Circuit(s) Card Devices)."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_VERSION=1.4.30
TERMUX_PKG_SRCURL=https://ccid.apdu.fr/files/ccid-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=ac17087be08880a0cdf99a8a2799a4ef004dc6ffa08b4d9b0ad995f39a53ff7c
TERMUX_PKG_DEPENDS="libpcsclite, libusb, flex"

termux_step_pre_configure() {
	export LEXLIB=$TERMUX_PREFIX/lib/libfl.so
}

TERMUX_PKG_HOMEPAGE=https://pcsclite.apdu.fr/
TERMUX_PKG_DESCRIPTION="Middleware to access a smart card using SCard API (PC/SC)."
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=1.9.0
TERMUX_PKG_SRCURL=https://pcsclite.apdu.fr/files/pcsc-lite-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=0148d403137124552c5d0f10f8cdab2cbb8dfc7c6ce75e018faf667be34f2ef9
TERMUX_PKG_DEPENDS="libusb, python2"
TERMUX_PKG_BREAKS="libpcsclite-dev"
TERMUX_PKG_REPLACES="libpcsclite-dev"
TERMUX_PKG_BUILD_DEPENDS="flex"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--exec-prefix=$TERMUX_PREFIX
--sbindir=$TERMUX_PREFIX/bin
--enable-ipcdir=$TERMUX_PREFIX/var/run
--disable-libsystemd
--disable-libudev"

TERMUX_PKG_HOMEPAGE=https://pcsclite.apdu.fr/
TERMUX_PKG_DESCRIPTION="Middleware to access a smart card using SCard API (PC/SC)."
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.9.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://pcsclite.apdu.fr/files/pcsc-lite-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=6956433c71dd17a902cd3f4a394ce48a1ea787faed526faf557c95cc434d3e59
TERMUX_PKG_DEPENDS="libusb, python"
TERMUX_PKG_BREAKS="libpcsclite-dev"
TERMUX_PKG_REPLACES="libpcsclite-dev"
TERMUX_PKG_BUILD_DEPENDS="flex"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--exec-prefix=$TERMUX_PREFIX
--sbindir=$TERMUX_PREFIX/bin
--enable-ipcdir=$TERMUX_PREFIX/var/run
--disable-libsystemd
--disable-libudev"


termux_step_create_debscripts() {
	# "pcscd fails to start if this folder does not exist"
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "mkdir -p $TERMUX_PREFIX/lib/pcsc/drivers" >> postinst
}

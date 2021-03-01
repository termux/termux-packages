TERMUX_PKG_HOMEPAGE=https://pcsclite.apdu.fr/
TERMUX_PKG_DESCRIPTION="Middleware to access a smart card using SCard API (PC/SC)."
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.9.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://pcsclite.apdu.fr/files/pcsc-lite-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=73c4789b7876a833a70f493cda21655dfe85689d9b7e29701c243276e55e683a
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

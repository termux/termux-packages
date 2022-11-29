TERMUX_PKG_HOMEPAGE=https://pcsclite.apdu.fr/
TERMUX_PKG_DESCRIPTION="Middleware to access a smart card using SCard API (PC/SC)."
TERMUX_PKG_LICENSE="BSD 3-Clause, GPL-3.0, BSD 2-Clause, ISC"
TERMUX_PKG_LICENSE_FILE="COPYING, GPL-3.0.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.9.9
TERMUX_PKG_SRCURL=https://pcsclite.apdu.fr/files/pcsc-lite-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=cbcc3b34c61f53291cecc0d831423c94d437b188eb2b97b7febc08de1c914e8a
TERMUX_PKG_DEPENDS="python"
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

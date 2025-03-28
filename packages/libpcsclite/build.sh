TERMUX_PKG_HOMEPAGE=https://pcsclite.apdu.fr/
TERMUX_PKG_DESCRIPTION="Middleware to access a smart card using SCard API (PC/SC)."
TERMUX_PKG_LICENSE="BSD 3-Clause, GPL-3.0, BSD 2-Clause, ISC"
TERMUX_PKG_LICENSE_FILE="COPYING, GPL-3.0.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.2
TERMUX_PKG_SRCURL=https://github.com/LudovicRousseau/PCSC/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=259008b57a86b10869428c5ba003abfec35388adee2ff9bb0380ad2de85f0533
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libusb, python"
TERMUX_PKG_BREAKS="libpcsclite-dev"
TERMUX_PKG_REPLACES="libpcsclite-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlibusb=true
-Dpolkit=false
-Dusbdropdir=$TERMUX_PREFIX/lib/pcsc/drivers
-Dipcdir=$TERMUX_PREFIX/var/run
-Dlibsystemd=false
-Dlibudev=false
"


termux_step_create_debscripts() {
	# "pcscd fails to start if this folder does not exist"
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "mkdir -p $TERMUX_PREFIX/lib/pcsc/drivers" >> postinst
}

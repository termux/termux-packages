TERMUX_PKG_HOMEPAGE=https://pcsclite.apdu.fr/
TERMUX_PKG_DESCRIPTION="Middleware to access a smart card using SCard API (PC/SC)."
TERMUX_PKG_LICENSE="BSD 3-Clause, GPL-3.0, BSD 2-Clause, ISC"
TERMUX_PKG_LICENSE_FILE="COPYING, GPL-3.0.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/LudovicRousseau/PCSC/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=00b667aa71504ed1d39a48ad377de048c70dbe47229e8c48a3239ab62979c70f
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libpcsclite-dev"
TERMUX_PKG_REPLACES="libpcsclite-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
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

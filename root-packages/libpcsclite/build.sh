TERMUX_PKG_HOMEPAGE=https://pcsclite.apdu.fr/
TERMUX_PKG_DESCRIPTION="Middleware to access a smart card using SCard API (PC/SC)."
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=1.8.24
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://pcsclite.apdu.fr/files/pcsc-lite-1.8.24.tar.bz2
TERMUX_PKG_SHA256=b81864fa6a5ec776639c02ae89998955f7702a8d10e8b8f70023c5a599d97568
TERMUX_PKG_DEPENDS="libusb"
TERMUX_PKG_DEVPACKAGE_DEPENDS="python2"
TERMUX_PKG_BUILD_DEPENDS="flex"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--exec-prefix=$TERMUX_PREFIX
--sbindir=$TERMUX_PREFIX/bin
--enable-ipcdir=$TERMUX_PREFIX/var/run
--disable-libsystemd
--disable-libudev"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/pcsc-spy share/man/man1/pcsc-spy.1.gz"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}

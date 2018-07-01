TERMUX_PKG_HOMEPAGE=https://marlam.de/msmtp/
TERMUX_PKG_DESCRIPTION="Lightweight SMTP client"
TERMUX_PKG_VERSION=1.6.8
TERMUX_PKG_SHA256=55ff95a304d888b56d07d9c62327ab9bfe26532c9c2a2ed6aefc43bea1b659fb
TERMUX_PKG_SRCURL=https://marlam.de/msmtp/releases/msmtp-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_DEPENDS="libgnutls, libidn"

termux_step_pre_configure () {
	LDFLAGS=" -llog"
	cp $TERMUX_SCRIPTDIR/packages/alpine/getpass* src/
	autoreconf -if
}

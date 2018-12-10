TERMUX_PKG_HOMEPAGE=https://marlam.de/msmtp/
TERMUX_PKG_DESCRIPTION="Lightweight SMTP client"
TERMUX_PKG_VERSION=1.8.1
TERMUX_PKG_SHA256=f0a2a7ed23a3ba5ca88640a9bc433507a79fdfc916b14a989d36679b7fdca4da
TERMUX_PKG_SRCURL=https://marlam.de/msmtp/releases/msmtp-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_DEPENDS="libgnutls, libidn"

termux_step_pre_configure () {
	LDFLAGS=" -llog"
	autoreconf -if
}

TERMUX_PKG_HOMEPAGE=https://marlam.de/msmtp/
TERMUX_PKG_DESCRIPTION="Lightweight SMTP client"
TERMUX_PKG_VERSION=1.6.7
TERMUX_PKG_SHA256=419da2ae177e95eb8fe698725d2cae43e50c77d11d5a3992ecc2739a05964357
TERMUX_PKG_SRCURL=https://marlam.de/msmtp/releases/msmtp-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_DEPENDS="libgnutls, libidn"

termux_step_pre_configure () {
	LDFLAGS=" -llog"
	cp $TERMUX_SCRIPTDIR/packages/alpine/getpass* src/
	autoreconf -if
}

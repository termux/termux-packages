TERMUX_PKG_HOMEPAGE=https://marlam.de/msmtp/
TERMUX_PKG_DESCRIPTION="Lightweight SMTP client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_API_LEVEL=23
TERMUX_PKG_VERSION=1.8.2
TERMUX_PKG_SHA256=d1185c1969ed00d0e2c57dbcd5eb09a9f82156042b21309d558f761978a58793
TERMUX_PKG_SRCURL=https://marlam.de/msmtp/releases/msmtp-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_DEPENDS="libgnutls, libidn"

termux_step_pre_configure() {
	LDFLAGS=" -llog"
	autoreconf -if
}

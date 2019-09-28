TERMUX_PKG_HOMEPAGE=https://marlam.de/msmtp/
TERMUX_PKG_DESCRIPTION="Lightweight SMTP client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=1.8.6
TERMUX_PKG_SRCURL=https://marlam.de/msmtp/releases/msmtp-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=6625f147430c65ba8527f52c4fe5d4d33552d3c0fb6d793ba7df819a3b3042e1
TERMUX_PKG_DEPENDS="openssl, libidn2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-tls=openssl"

termux_step_pre_configure() {
	export LIBS="-llog"
	autoreconf -if
}

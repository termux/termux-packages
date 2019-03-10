TERMUX_PKG_HOMEPAGE=https://marlam.de/msmtp/
TERMUX_PKG_DESCRIPTION="Lightweight SMTP client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=1.8.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=3cb2eefd33d048f0f82de100ef39a494e44fd1485e376ead31f733d2f36b92b4
TERMUX_PKG_SRCURL=https://marlam.de/msmtp/releases/msmtp-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_DEPENDS="openssl, libidn2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-tls=openssl"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
	autoreconf -if
}

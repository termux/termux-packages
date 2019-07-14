TERMUX_PKG_HOMEPAGE=https://marlam.de/msmtp/
TERMUX_PKG_DESCRIPTION="Lightweight SMTP client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=1.8.5
TERMUX_PKG_SRCURL=https://marlam.de/msmtp/releases/msmtp-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=1613daced9c47b8c028224fc076799c2a4d72923e242be4e9e5c984cbbbb9f39
TERMUX_PKG_DEPENDS="openssl, libidn2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-tls=openssl"

termux_step_pre_configure() {
	LDFLAGS=" -llog"
	autoreconf -if
	cp $TERMUX_PKG_BUILDER_DIR/ns_parse.h src/
}

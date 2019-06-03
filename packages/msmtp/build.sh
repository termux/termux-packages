TERMUX_PKG_HOMEPAGE=https://marlam.de/msmtp/
TERMUX_PKG_DESCRIPTION="Lightweight SMTP client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=1.8.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=e5dd7fe95bc8e2f5eea3e4894ec9628252f30bd700a7fd1a568b10efa91129f7
TERMUX_PKG_SRCURL=https://marlam.de/msmtp/releases/msmtp-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_DEPENDS="openssl, libidn2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-tls=openssl"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
	autoreconf -if
}

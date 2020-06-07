TERMUX_PKG_HOMEPAGE=https://marlam.de/msmtp/
TERMUX_PKG_DESCRIPTION="Lightweight SMTP client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=1.8.11
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://marlam.de/msmtp/releases/msmtp-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=f25f0fa177ce9e0ad65c127e790a37f35fb64fee9e33d90345844c5c86780e60
TERMUX_PKG_DEPENDS="openssl, libidn2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-tls=openssl"

termux_step_pre_configure() {
	autoreconf -if
}

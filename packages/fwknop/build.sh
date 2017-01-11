TERMUX_PKG_HOMEPAGE=http://www.cipherdyne.org/fwknop/
TERMUX_PKG_DESCRIPTION="fwknop: Single Packet Authorization > Port Knocking"
TERMUX_PKG_VERSION=2.6.9
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://www.cipherdyne.org/fwknop/download/fwknop-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="gpgme"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-server --with-gpgme"

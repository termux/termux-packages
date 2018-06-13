TERMUX_PKG_HOMEPAGE=http://www.cipherdyne.org/fwknop/
TERMUX_PKG_DESCRIPTION="fwknop: Single Packet Authorization > Port Knocking"
TERMUX_PKG_VERSION=2.6.9
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=http://www.cipherdyne.org/fwknop/download/fwknop-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=5bf47fe1fd30e862d29464f762c0b8bf89b5e298665c37624d6707826da956d4
TERMUX_PKG_DEPENDS="gpgme"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-server
--with-gpgme
--with-gpg=$TERMUX_PREFIX/bin/gpg2
"

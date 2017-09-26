TERMUX_PKG_HOMEPAGE=https://www.aleksey.com/xmlsec/
TERMUX_PKG_DESCRIPTION="XML Security Library"
TERMUX_PKG_VERSION=1.2.25
TERMUX_PKG_SHA256=967ca83edf25ccb5b48a3c4a09ad3405a63365576503bf34290a42de1b92fcd2
TERMUX_PKG_SRCURL=http://www.aleksey.com/xmlsec/download/xmlsec1-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libxslt, openssl, libgcrypt, libgpg-error"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-crypto-dl
--without-gnutls
"

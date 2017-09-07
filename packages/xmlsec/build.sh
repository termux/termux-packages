TERMUX_PKG_HOMEPAGE=https://www.aleksey.com/xmlsec/
TERMUX_PKG_DESCRIPTION="XML Security Library"
TERMUX_PKG_VERSION=1.2.24
TERMUX_PKG_SHA256=99a8643f118bb1261a72162f83e2deba0f4f690893b4b90e1be4f708e8d481cc
TERMUX_PKG_SRCURL=http://www.aleksey.com/xmlsec/download/xmlsec1-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libxslt, openssl, libgcrypt, libgpg-error"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-crypto-dl
--without-gnutls
"

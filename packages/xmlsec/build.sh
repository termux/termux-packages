TERMUX_PKG_HOMEPAGE=https://www.aleksey.com/xmlsec/
TERMUX_PKG_DESCRIPTION="XML Security Library"
TERMUX_PKG_VERSION=1.2.26
TERMUX_PKG_SHA256=8d8276c9c720ca42a3b0023df8b7ae41a2d6c5f9aa8d20ed1672d84cc8982d50
TERMUX_PKG_SRCURL=http://www.aleksey.com/xmlsec/download/xmlsec1-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libxslt, openssl, libgcrypt, libgpg-error"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-crypto-dl
--without-gnutls
"

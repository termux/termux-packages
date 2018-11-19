TERMUX_PKG_HOMEPAGE=https://www.aleksey.com/xmlsec/
TERMUX_PKG_DESCRIPTION="XML Security Library"
TERMUX_PKG_VERSION=1.2.27
TERMUX_PKG_SHA256=97d756bad8e92588e6997d2227797eaa900d05e34a426829b149f65d87118eb6
TERMUX_PKG_SRCURL=http://www.aleksey.com/xmlsec/download/xmlsec1-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libxslt, openssl, libgcrypt, libgpg-error"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-crypto-dl
--without-gnutls
"

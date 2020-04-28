TERMUX_PKG_HOMEPAGE=https://www.aleksey.com/xmlsec/
TERMUX_PKG_DESCRIPTION="XML Security Library"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=1.2.30
TERMUX_PKG_SRCURL=http://www.aleksey.com/xmlsec/download/xmlsec1-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2d84360b03042178def1d9ff538acacaed2b3a27411db7b2874f1612ed71abc8
TERMUX_PKG_DEPENDS="libxslt, openssl, libgcrypt, libgpg-error, libxml2"
TERMUX_PKG_BREAKS="xmlsec-dev"
TERMUX_PKG_REPLACES="xmlsec-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-crypto-dl
--without-gnutls
"

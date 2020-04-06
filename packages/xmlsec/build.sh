TERMUX_PKG_HOMEPAGE=https://www.aleksey.com/xmlsec/
TERMUX_PKG_DESCRIPTION="XML Security Library"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=1.2.29
TERMUX_PKG_SRCURL=http://www.aleksey.com/xmlsec/download/xmlsec1-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b1d1deba966019930f608d1f2b95c40ca3450f1393bcd3a3c001a8ba1d2839ab
TERMUX_PKG_DEPENDS="libxslt, openssl, libgcrypt, libgpg-error, libxml2"
TERMUX_PKG_BREAKS="xmlsec-dev"
TERMUX_PKG_REPLACES="xmlsec-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-crypto-dl
--without-gnutls
"

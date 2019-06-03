TERMUX_PKG_HOMEPAGE=https://www.aleksey.com/xmlsec/
TERMUX_PKG_DESCRIPTION="XML Security Library"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=1.2.28
TERMUX_PKG_SHA256=13eec4811ea30e3f0e16a734d1dbf7f9d246a71d540b48d143a07b489f6222d4
TERMUX_PKG_SRCURL=http://www.aleksey.com/xmlsec/download/xmlsec1-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libxslt, openssl, libgcrypt, libgpg-error, libxml2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-crypto-dl
--without-gnutls
"

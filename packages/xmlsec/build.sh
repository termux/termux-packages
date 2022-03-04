TERMUX_PKG_HOMEPAGE=https://www.aleksey.com/xmlsec/
TERMUX_PKG_DESCRIPTION="XML Security Library"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.31
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=http://www.aleksey.com/xmlsec/download/xmlsec1-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9b10bc52cc31e4f76162e3975e50db26b71ab49c571d810b311ca626be5a0b26
TERMUX_PKG_DEPENDS="libxslt, openssl, libgcrypt, libgpg-error, libxml2"
TERMUX_PKG_BREAKS="xmlsec-dev"
TERMUX_PKG_REPLACES="xmlsec-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-crypto-dl
--without-gnutls
"

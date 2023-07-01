TERMUX_PKG_HOMEPAGE=https://www.aleksey.com/xmlsec/
TERMUX_PKG_DESCRIPTION="XML Security Library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="Copyright"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.1
TERMUX_PKG_SRCURL=https://www.aleksey.com/xmlsec/download/xmlsec1-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=10f48384d4fd1afc05fea545b74fbf7c152582f0a895c189f164d55270400c63
TERMUX_PKG_DEPENDS="libgcrypt, libxml2 (>= 2.11.4-2), libxslt, openssl"
TERMUX_PKG_BREAKS="xmlsec-dev"
TERMUX_PKG_REPLACES="xmlsec-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-crypto-dl
--without-gnutls
--without-pedantic
"

termux_step_post_get_source() {
	echo >> src/openssl/symkeys.c
}

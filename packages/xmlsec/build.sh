TERMUX_PKG_HOMEPAGE=https://www.aleksey.com/xmlsec/
TERMUX_PKG_DESCRIPTION="XML Security Library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="Copyright"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.8"
TERMUX_PKG_SRCURL=https://github.com/lsh123/xmlsec/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7a8a6efdbfdb2bf3a7f56f91d116254e8c93e24d2f054c9ba6fb1e903bd5b09a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libgcrypt, libxml2, libnspr, libnss, libxslt, openssl"
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

termux_step_pre_configure() {
	autoreconf -fi
}

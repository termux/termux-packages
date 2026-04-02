TERMUX_PKG_HOMEPAGE=https://www.aleksey.com/xmlsec/
TERMUX_PKG_DESCRIPTION="XML Security Library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="Copyright"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.10"
TERMUX_PKG_SRCURL=https://github.com/lsh123/xmlsec/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f7731ea4168b45d8652c6a889724cf1440bf7799d83271940b4379ab2ca06788
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

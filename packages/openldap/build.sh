##
##  COMPLETELY UNTESTED.
##

TERMUX_PKG_HOMEPAGE=https://openldap.org
TERMUX_PKG_DESCRIPTION="OpenLDAP server"
TERMUX_PKG_LICENSE="OpenLDAP"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.4.48
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-$TERMUX_PKG_VERSION.tgz
TERMUX_PKG_SHA256=d9523ffcab5cd14b709fcf3cb4d04e8bc76bb8970113255f372bc74954c6074d
TERMUX_PKG_DEPENDS="libsasl, libuuid, openssl"
TERMUX_PKG_BREAKS="openldap-dev"
TERMUX_PKG_REPLACES="openldap-dev"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ol_cv_lib_icu=no
ac_cv_func_memcmp_working=yes
--enable-dynamic
--with-yielding_select=yes
--enable-backends=no
--enable-monitor
--enable-mdb
--enable-ldap"

termux_step_pre_configure() {
	CFLAGS+=" -DMDB_USE_ROBUST=0"
	LDFLAGS+=" -lcrypto -llog"
}

termux_step_make_install() {
	make STRIP="" install
}

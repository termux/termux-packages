TERMUX_PKG_HOMEPAGE=https://openldap.org
TERMUX_PKG_DESCRIPTION="OpenLDAP server"
TERMUX_PKG_LICENSE="OpenLDAP"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.4
TERMUX_PKG_SRCURL=https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=d51704e50178430c06cf3d8aa174da66badf559747a47d920bb54b2d4aa40991
TERMUX_PKG_DEPENDS="libsasl, libuuid (>> 2.38.1), openssl"
TERMUX_PKG_BREAKS="openldap-dev"
TERMUX_PKG_REPLACES="openldap-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="STRIP="
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

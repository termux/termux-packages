TERMUX_PKG_HOMEPAGE=https://openldap.org
TERMUX_PKG_DESCRIPTION="OpenLDAP server"
TERMUX_PKG_LICENSE="OpenLDAP"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.5.4
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-$TERMUX_PKG_VERSION.tgz
TERMUX_PKG_SHA256=61c03c078d70cd859e504fa9555d7d52426eed4b29e6a39e828afc213e4fb356
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

	local slot=${TERMUX_PKG_VERSION%.*}
	for lib in lber ldap; do
		local target=lib${lib}-${slot}.so
		if [ -e $TERMUX_PREFIX/lib/${target} ]; then
			ln -sf ${target} $TERMUX_PREFIX/lib/lib${lib}.so
		fi
	done
}

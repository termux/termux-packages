TERMUX_PKG_HOMEPAGE=https://openldap.org
TERMUX_PKG_DESCRIPTION="OpenLDAP server"
TERMUX_PKG_VERSION=2.4.45
TERMUX_PKG_SRCURL=ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-$TERMUX_PKG_VERSION.tgz
TERMUX_PKG_DEPENDS="libsasl, openssl, libuuid"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_SHA256=cdd6cffdebcd95161a73305ec13fc7a78e9707b46ca9f84fb897cd5626df3824
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" ol_cv_lib_icu=no \
--enable-dynamic \
ac_cv_func_memcmp_working=yes \
--with-yielding_select=yes \
--enable-backends=no \
--enable-monitor \
--enable-mdb \
--enable-ldap"
termux_step_pre_configure() {
	LDFLAGS+=" -llog"
	CFLAGS+=" -DMDB_USE_ROBUST=0"
}
termux_step_make_install() {
	make STRIP="" install
}

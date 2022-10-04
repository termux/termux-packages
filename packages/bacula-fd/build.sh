TERMUX_PKG_HOMEPAGE=https://www.bacula.org
TERMUX_PKG_DESCRIPTION="Bacula backup software"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="Matlink <matlink@matlink.fr>"
TERMUX_PKG_VERSION=13.0.1
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/bacula/files/bacula/${TERMUX_PKG_VERSION}/bacula-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d63848d695ac15c1ccfc117892753314bcb9232a852c40e32cca88c0e918978a
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES=etc/bacula/bacula-fd.conf
TERMUX_PKG_SERVICE_SCRIPT=("bacula-fd" "${TERMUX_PREFIX}/bin/bacula-fd")
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sysconfdir=${TERMUX_PREFIX}/etc/bacula
--with-plugindir=${TERMUX_PREFIX}/lib/bacula
--mandir=${TERMUX_PREFIX}/share/man
--with-logdir=${TERMUX_PREFIX}/var/log
--with-working-dir=${TERMUX_PREFIX}/var/run/bacula
--with-pid-dir=${TERMUX_PREFIX}/var/run/bacula
--with-scriptdir=${TERMUX_PREFIX}/etc/bacula/scripts
--with-ssl
--enable-smartalloc
--enable-conio
--enable-client-only
--with-baseport=9102
ac_cv_func_setpgrp_void=yes
"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
	LDFLAGS+=" -Wl,-rpath=${TERMUX_PREFIX}/lib/bacula -Wl,--enable-new-dtags"
}

termux_step_post_massage() {
	mkdir -p ${TERMUX_PKG_MASSAGEDIR}${TERMUX_PREFIX}/var/run/bacula
}

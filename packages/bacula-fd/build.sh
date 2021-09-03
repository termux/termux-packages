TERMUX_PKG_HOMEPAGE=https://www.bacula.org
TERMUX_PKG_DESCRIPTION="Bacula backup software"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="Matlink <matlink@matlink.fr>, github.com/matlink, twitter.com/m4tlink"
TERMUX_PKG_VERSION=11.0.5
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/bacula/files/bacula/${TERMUX_PKG_VERSION}/bacula-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ef5b3b67810442201b80dc1d47ccef77b5ed378fe1285406f3a73401b6e8111a
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_DEPENDS="openssl"
BACULA_PREFIX=${TERMUX_PREFIX}/opt/bacula
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES=${BACULA_PREFIX}/etc/bacula-fd.conf
TERMUX_PKG_SERVICE_SCRIPT=("bacula-fd" "${BACULA_PREFIX}/bin/bacula-fd")
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sbindir=${BACULA_PREFIX}/bin
--sysconfdir=${BACULA_PREFIX}/etc
--docdir=${BACULA_PREFIX}/html
--htmldir=${BACULA_PREFIX}/html
--mandir=${BACULA_PREFIX}/man
--with-logdir=${BACULA_PREFIX}/log
--with-working-dir=${BACULA_PREFIX}/working
--with-pid-dir=${BACULA_PREFIX}/working
--with-scriptdir=${BACULA_PREFIX}/scripts
--with-plugindir=${BACULA_PREFIX}/plugins
--libdir=${BACULA_PREFIX}/lib
--with-ssl
--enable-smartalloc
--enable-conio
--enable-client-only
--with-baseport=9102
ac_cv_func_setpgrp_void=yes
"

termux_step_post_massage() {
	mkdir -p ${TERMUX_PKG_MASSAGEDIR}${BACULA_PREFIX}/working
}

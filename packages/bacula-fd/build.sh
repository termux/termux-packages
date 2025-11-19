TERMUX_PKG_HOMEPAGE=https://www.bacula.org
TERMUX_PKG_DESCRIPTION="Bacula backup software"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="15.0.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/bacula/files/bacula/${TERMUX_PKG_VERSION}/bacula-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=294afd3d2eb9d5b71c3d0e88fdf19eb513bfdb843b28d35c0552e4ae062827a1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, liblzo, openssl, zlib"
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
--with-lzo=${TERMUX_PREFIX}
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

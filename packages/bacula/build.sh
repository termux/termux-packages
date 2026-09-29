TERMUX_PKG_HOMEPAGE=https://www.bacula.org
TERMUX_PKG_DESCRIPTION="Bacula backup software"
TERMUX_PKG_LICENSE="AGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="17.0.0"
TERMUX_PKG_SRCURL="https://gitlab.bacula.org/bacula-community-edition/bacula-community/-/archive/Release-${TERMUX_PKG_VERSION}/bacula-community-Release-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=7577f2d9b2d0e4daa826473ad63d652095ca2d862e517b947cc2d38bada5726a
TERMUX_PKG_DEPENDS="libc++, liblzo, openssl, zlib"
TERMUX_PKG_BREAKS="bacula-fd"
TERMUX_PKG_REPLACES="bacula-fd"
TERMUX_PKG_PROVIDES="bacula-fd"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/bacula/bacula-fd.conf"
TERMUX_PKG_SERVICE_SCRIPT=("bacula-fd" "${TERMUX_PREFIX}/bin/bacula-fd")
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_setpgrp_void=yes
--enable-client-only
--enable-conio
--enable-smartalloc
--mandir=${TERMUX_PREFIX}/share/man
--sysconfdir=${TERMUX_PREFIX}/etc/bacula
--with-baseport=9102
--with-logdir=${TERMUX_PREFIX}/var/log
--with-lzo=${TERMUX_PREFIX}
--with-pid-dir=${TERMUX_PREFIX}/var/run/bacula
--with-plugindir=${TERMUX_PREFIX}/lib/bacula
--with-scriptdir=${TERMUX_PREFIX}/etc/bacula/scripts
--with-ssl
--with-working-dir=${TERMUX_PREFIX}/var/run/bacula
"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
	LDFLAGS+=" -Wl,-rpath=${TERMUX_PREFIX}/lib/bacula -Wl,--enable-new-dtags"
}

termux_step_post_massage() {
	mkdir -p "${TERMUX_PKG_MASSAGEDIR}${TERMUX_PREFIX}/var/run/bacula"
}

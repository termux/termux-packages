TERMUX_PKG_HOMEPAGE=https://apr.apache.org/
TERMUX_PKG_DESCRIPTION="Apache Portable Runtime Utility Library"
TERMUX_PKG_VERSION=1.6.0
TERMUX_PKG_DEPENDS="apr, libexpat"
TERMUX_PKG_SRCURL=http://apache.mirrors.spacedump.net/apr/apr-util-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=8474c93fa74b56ac6ca87449abe3e155723d5f534727f3f33283f6631a48ca4c
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_pq_PQsendQueryPrepared=no
--with-apr=$TERMUX_PREFIX
--without-sqlite3
"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/apu-1-config"
TERMUX_PKG_RM_AFTER_INSTALL="bin/apu-1-config lib/aprutil.exp"

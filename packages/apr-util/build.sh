TERMUX_PKG_HOMEPAGE=https://apr.apache.org/
TERMUX_PKG_DESCRIPTION="Apache Portable Runtime Utility Library"
TERMUX_PKG_VERSION=1.5.4
TERMUX_PKG_REVISION=2
TERMUX_PKG_DEPENDS="apr, libexpat"
TERMUX_PKG_SRCURL=http://apache.mirrors.spacedump.net/apr/apr-util-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=a6cf327189ca0df2fb9d5633d7326c460fe2b61684745fd7963e79a6dd0dc82e
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_pq_PQsendQueryPrepared=no
--with-apr=$TERMUX_PREFIX
--without-sqlite3
"
TERMUX_PKG_RM_AFTER_INSTALL="bin/apu-1-config lib/aprutil.exp"

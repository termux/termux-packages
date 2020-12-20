TERMUX_PKG_HOMEPAGE=https://apr.apache.org/
TERMUX_PKG_DESCRIPTION="Apache Portable Runtime Utility Library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=http://apache.mirrors.spacedump.net/apr/apr-util-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=d3e12f7b6ad12687572a3a39475545a072608f4ba03a6ce8a3778f607dd0035b
TERMUX_PKG_DEPENDS="apr, libcrypt, libexpat, libiconv, libuuid"
TERMUX_PKG_BREAKS="apr-util-dev"
TERMUX_PKG_REPLACES="apr-util-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_pq_PQsendQueryPrepared=no
--with-apr=$TERMUX_PREFIX
--without-sqlite3
"
TERMUX_PKG_RM_AFTER_INSTALL="lib/aprutil.exp"

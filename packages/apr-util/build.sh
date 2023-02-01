TERMUX_PKG_HOMEPAGE=https://apr.apache.org/
TERMUX_PKG_DESCRIPTION="Apache Portable Runtime Utility Library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.2
TERMUX_PKG_SRCURL=https://downloads.apache.org/apr/apr-util-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fe3aa01c17d3cbef399872ae36d8541010a5c03be321beede3ed78b87a1764e0
TERMUX_PKG_DEPENDS="apr, libcrypt, libexpat, libiconv, libuuid (>> 2.38.1)"
TERMUX_PKG_BREAKS="apr-util-dev"
TERMUX_PKG_REPLACES="apr-util-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_pq_PQsendQueryPrepared=no
--with-apr=$TERMUX_PREFIX
--without-sqlite3
"
TERMUX_PKG_RM_AFTER_INSTALL="lib/aprutil.exp"

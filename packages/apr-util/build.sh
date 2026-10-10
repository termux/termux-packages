TERMUX_PKG_HOMEPAGE=https://apr.apache.org/
TERMUX_PKG_DESCRIPTION="Apache Portable Runtime Utility Library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.5"
TERMUX_PKG_SRCURL="https://downloads.apache.org/apr/apr-util-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f43a1c8c79eef497a022ec6c99dddbdf57e42001da6ccbfae259631ed5aa2805
TERMUX_PKG_DEPENDS="apr, libcrypt, libexpat, libiconv, libuuid"
TERMUX_PKG_BREAKS="apr-util-dev"
TERMUX_PKG_REPLACES="apr-util-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_pq_PQsendQueryPrepared=no
--with-apr=$TERMUX_PREFIX
--without-sqlite3
"
TERMUX_PKG_RM_AFTER_INSTALL="lib/aprutil.exp"

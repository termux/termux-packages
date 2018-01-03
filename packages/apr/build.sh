TERMUX_PKG_HOMEPAGE=https://apr.apache.org/
TERMUX_PKG_DESCRIPTION="Apache Portable Runtime Library"
TERMUX_PKG_VERSION=1.6.3
TERMUX_PKG_SHA256=131f06d16d7aabd097fa992a33eec2b6af3962f93e6d570a9bd4d85e95993172
TERMUX_PKG_SRCURL=http://apache.mirrors.spacedump.net/apr/apr-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="libuuid"
TERMUX_PKG_BUILD_IN_SRC="yes"
# "ac_cv_search_crypt=" to avoid needlessly linking to libcrypt.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-installbuilddir=$TERMUX_PREFIX/share/apr-1/build
ac_cv_file__dev_zero=yes
ac_cv_func_setpgrp_void=yes
apr_cv_process_shared_works=no
apr_cv_tcp_nodelay_with_cork=yes
ac_cv_sizeof_struct_iovec=$(( TERMUX_ARCH_BITS==32 ? 8 : 16 ))
ac_cv_search_crypt="
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/apr-1-config share/apr-1/build"
TERMUX_PKG_RM_AFTER_INSTALL="lib/apr.exp"

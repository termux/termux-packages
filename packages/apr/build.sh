TERMUX_PKG_HOMEPAGE=https://apr.apache.org/
TERMUX_PKG_VERSION=1.5.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://apache.mirrors.spacedump.net/apr/apr-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=7d03ed29c22a7152be45b8e50431063736df9e1daa1ddf93f6a547ba7a28f67a
TERMUX_PKG_DESCRIPTION="Apache Portable Runtime - library providing a predictable and consistent interface to underlying platform-specific implementations"
TERMUX_PKG_DEPENDS="libuuid"
TERMUX_PKG_BUILD_IN_SRC="yes"
# "ac_cv_search_crypt=" to avoid needlessly linking to libcrypt.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-installbuilddir=$TERMUX_PKG_TMPDIR ac_cv_file__dev_zero=yes ac_cv_func_setpgrp_void=yes apr_cv_process_shared_works=no apr_cv_tcp_nodelay_with_cork=yes ac_cv_sizeof_struct_iovec=8 ac_cv_search_crypt="
TERMUX_PKG_RM_AFTER_INSTALL="bin/apr-1-config lib/apr.exp"

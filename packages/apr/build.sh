TERMUX_PKG_HOMEPAGE=https://apr.apache.org/
TERMUX_PKG_VERSION=1.6.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://apache.mirrors.spacedump.net/apr/apr-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=09109cea377bab0028bba19a92b5b0e89603df9eab05c0f7dbd4dd83d48dcebd
TERMUX_PKG_DESCRIPTION="Apache Portable Runtime - library providing a predictable and consistent interface to underlying platform-specific implementations"
TERMUX_PKG_DEPENDS="libuuid"
TERMUX_PKG_BUILD_IN_SRC="yes"
# "ac_cv_search_crypt=" to avoid needlessly linking to libcrypt.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-installbuilddir=$TERMUX_PKG_TMPDIR ac_cv_file__dev_zero=yes ac_cv_func_setpgrp_void=yes apr_cv_process_shared_works=no apr_cv_tcp_nodelay_with_cork=yes ac_cv_sizeof_struct_iovec=8 ac_cv_search_crypt="
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/apr-1-config"
TERMUX_PKG_RM_AFTER_INSTALL="lib/apr.exp"

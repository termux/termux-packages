TERMUX_PKG_HOMEPAGE=https://apr.apache.org/
TERMUX_PKG_DESCRIPTION="Apache Portable Runtime Library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=1.6.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=a67ca9fcf9c4ff59bce7f428a323c8b5e18667fdea7b0ebad47d194371b0a105
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

termux_step_post_make_install() {
	sed -i "s%NM=\".*%NM=\"${TERMUX_HOST_PLATFORM}-nm -B\"%g" $TERMUX_PREFIX/share/apr-1/build/libtool
}

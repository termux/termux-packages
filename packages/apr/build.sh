TERMUX_PKG_HOMEPAGE=https://apr.apache.org/
TERMUX_PKG_DESCRIPTION="Apache Portable Runtime Library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.7.2
TERMUX_PKG_SRCURL=https://dlcdn.apache.org/apr/apr-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=75e77cc86776c030c0a5c408dfbd0bf2a0b75eed5351e52d5439fa1e5509a43e
TERMUX_PKG_DEPENDS="libuuid (>> 2.38.1)"
TERMUX_PKG_BREAKS="apr-dev"
TERMUX_PKG_REPLACES="apr-dev"
TERMUX_PKG_BUILD_IN_SRC=true
# "ac_cv_search_crypt=" to avoid needlessly linking to libcrypt.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-installbuilddir=$TERMUX_PREFIX/share/apr-1/build
ac_cv_func_getrandom=no
ac_cv_have_decl_SYS_getrandom=no
ap_cv_atomic_builtins=yes
apr_cv_mutex_recursive=yes
apr_cv_epoll=yes
apr_cv_epoll_create1=yes
apr_cv_dup3=yes
apr_cv_accept4=yes
apr_cv_sock_cloexec=yes
ac_cv_file__dev_zero=yes
ac_cv_strerror_r_rc_int=yes
ac_cv_func_setpgrp_void=yes
ac_cv_struct_rlimit=yes
ac_cv_func_sem_open=no
apr_cv_process_shared_works=yes
apr_cv_mutex_robust_shared=no
ac_cv_o_nonblock_inherited=no
apr_cv_tcp_nodelay_with_cork=yes
apr_cv_gai_addrconfig=yes
ac_cv_sizeof_pid_t=4
ac_cv_sizeof_ssize_t=$(( TERMUX_ARCH_BITS==32 ? 4 : 8 ))
ac_cv_sizeof_size_t=$(( TERMUX_ARCH_BITS==32 ? 4 : 8 ))
ac_cv_sizeof_off_t=$(( TERMUX_ARCH_BITS==32 ? 4 : 8 ))
ac_cv_sizeof_struct_iovec=$(( TERMUX_ARCH_BITS==32 ? 8 : 16 ))
ac_cv_search_crypt="
TERMUX_PKG_RM_AFTER_INSTALL="lib/apr.exp"

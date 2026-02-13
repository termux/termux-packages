TERMUX_PKG_HOMEPAGE=http://www.dest-unreach.org/socat/
TERMUX_PKG_DESCRIPTION="Relay for bidirectional data transfer between two independent data channels"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.1.1"
TERMUX_PKG_SRCURL=http://www.dest-unreach.org/socat/download/socat-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f68b602c80e94b4b7498d74ec408785536fe33534b39467977a82ab2f7f01ddb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-posixmq
ac_cv_header_resolv_h=no
ac_cv_c_compiler_gnu=yes
ac_compiler_gnu=yes
sc_cv_getprotobynumber_r=
" # sc_cv_sys_crdly_shift=9 sc_cv_sys_csize_shift=4 sc_cv_sys_tabdly_shift=11"
TERMUX_PKG_BUILD_IN_SRC=true

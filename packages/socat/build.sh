TERMUX_PKG_HOMEPAGE=http://www.dest-unreach.org/socat/
TERMUX_PKG_DESCRIPTION="Relay for bidirectional data transfer between two independent data channels"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_DEPENDS="openssl, readline, libutil"
TERMUX_PKG_VERSION=1.7.3.3
TERMUX_PKG_SHA256=8cc0eaee73e646001c64adaab3e496ed20d4d729aaaf939df2a761e99c674372
TERMUX_PKG_SRCURL=http://www.dest-unreach.org/socat/download/socat-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_header_resolv_h=no ac_cv_c_compiler_gnu=yes ac_compiler_gnu=yes" # sc_cv_sys_crdly_shift=9 sc_cv_sys_csize_shift=4 sc_cv_sys_tabdly_shift=11"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export LIBS="-llog"
}

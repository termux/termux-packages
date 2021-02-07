TERMUX_PKG_HOMEPAGE=http://www.dest-unreach.org/socat/
TERMUX_PKG_DESCRIPTION="Relay for bidirectional data transfer between two independent data channels"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.7.4.1
TERMUX_PKG_SRCURL=http://www.dest-unreach.org/socat/download/socat-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0c7e635070af1b9037fd96869fc45eacf9845cb54547681de9d885044538736d
TERMUX_PKG_DEPENDS="openssl, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_header_resolv_h=no ac_cv_c_compiler_gnu=yes ac_compiler_gnu=yes" # sc_cv_sys_crdly_shift=9 sc_cv_sys_csize_shift=4 sc_cv_sys_tabdly_shift=11"
TERMUX_PKG_BUILD_IN_SRC=true
# Broken 32bit support.
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

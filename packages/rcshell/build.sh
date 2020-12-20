TERMUX_PKG_HOMEPAGE=http://tobold.org/article/rc
TERMUX_PKG_DESCRIPTION="An alternative implementation of the plan 9 rc shell"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.7.4
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://sources.voidlinux.org/rc-${TERMUX_PKG_VERSION}/rc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5ed26334dd0c1a616248b15ad7c90ca678ae3066fa02c5ddd0e6936f9af9bfd8
TERMUX_PKG_DEPENDS="readline"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_setpgrp_void=yes
rc_cv_sysv_sigcld=no
"

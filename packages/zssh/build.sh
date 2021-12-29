TERMUX_PKG_HOMEPAGE=http://zssh.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A program for interactively transferring files to a remote machine while using the secure shell (ssh)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5c
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/zssh/zssh-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=a2e840f82590690d27ea1ea1141af509ee34681fede897e58ae8d354701ce71b
TERMUX_PKG_DEPENDS="libandroid-glob, lrzsz, openssh, readline"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	echo "ac_cv_func_getpgrp_void=yes" >> config.cache
	LDFLAGS+=" -landroid-glob"
}

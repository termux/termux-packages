TERMUX_PKG_HOMEPAGE=https://0pointer.de/lennart/projects/libdaemon/
TERMUX_PKG_DESCRIPTION="A lightweight C library that eases the writing of UNIX daemons"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.14
TERMUX_PKG_SRCURL=https://0pointer.de/lennart/projects/libdaemon/libdaemon-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fd23eb5f6f986dcc7e708307355ba3289abe03cc381fc47a80bca4a50aa6b834
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_setpgrp_void=yes"

termux_step_pre_configure() {
	autoreconf -fi
}

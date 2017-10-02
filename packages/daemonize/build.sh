TERMUX_PKG_HOMEPAGE=http://software.clapper.org/daemonize/
TERMUX_PKG_DESCRIPTION="Run a command as a Unix daemon"
TERMUX_PKG_VERSION=1.7.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/bmc/daemonize/archive/release-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b3cafea3244ed5015a3691456644386fc438102adbdc305af553928a185bea05
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_setpgrp_void=yes"

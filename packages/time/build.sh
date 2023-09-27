TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/time/
TERMUX_PKG_DESCRIPTION="GNU time program for measuring CPU resource usage"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.9
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/time/time-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fbacf0c81e62429df3e33bda4cee38756604f18e01d977338e23306a3e3b521e
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_wait3_rusage=yes"

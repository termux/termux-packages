TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/time/
TERMUX_PKG_DESCRIPTION="GNU time program for measuring CPU resource usage"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.10
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/time/time-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e8c29fb4ab599d8478e41e8618f50db8aede9c90af27d0d2ef28ae50d5de09c3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_wait3_rusage=yes"

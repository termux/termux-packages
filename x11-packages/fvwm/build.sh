TERMUX_PKG_HOMEPAGE=https://www.fvwm.org/
TERMUX_PKG_DESCRIPTION="A multiple large virtual desktop window manager originally derived from twm."
# Licenses: GPL-2.0, FVWM
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.7.0
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://github.com/fvwmorg/fvwm/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a0662354ce5762e894665a27e59b437cb422bfe738a8cf901665c6ee0d0b9ab8
TERMUX_PKG_DEPENDS="fontconfig, fribidi, glib, libandroid-shmem, libcairo, libice, libiconv, libpng, librsvg, libsm, libx11, libxcursor, libxext, libxft, libxinerama, libxpm, libxrender, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_setpgrp_void=yes ac_cv_func_mkstemp=no ac_cv_func_getpwuid=no"

termux_step_pre_configure() {
	autoreconf -fi
	export LIBS="-landroid-shmem"
}

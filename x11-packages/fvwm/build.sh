TERMUX_PKG_HOMEPAGE=https://www.fvwm.org/
TERMUX_PKG_DESCRIPTION="A multiple large virtual desktop window manager originally derived from twm."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=2.7.0
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/fvwmorg/fvwm/releases/download/2.6.9/fvwm-2.6.9.tar.gz
TERMUX_PKG_SHA256=1bc64cf3ccd0073008758168327a8265b8059def9b239b451d6b9fab2cc391ae
TERMUX_PKG_DEPENDS="fribidi, librsvg, libxcursor, libxinerama, libxpm, imlib2, libandroid-shmem"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_setpgrp_void=yes ac_cv_func_mkstemp=no ac_cv_func_getpwuid=no"

termux_step_pre_configure() {
	export LIBS="-landroid-shmem"
}

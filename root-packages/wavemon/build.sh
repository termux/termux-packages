TERMUX_PKG_HOMEPAGE=https://github.com/uoaerg/wavemon
TERMUX_PKG_DESCRIPTION="Ncurses-based monitoring application for wireless network devices"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.9.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/uoaerg/wavemon/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5823ef9459d6147a457b390b6744a77465584e93d37c2809fa7a0be557070166
TERMUX_PKG_DEPENDS="libcap, libnl, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_pthread_pthread_create=yes"

termux_step_pre_configure() {
	CPPFLAGS+=" -I$TERMUX_PREFIX/include/libnl3"
}

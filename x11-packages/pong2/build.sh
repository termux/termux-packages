TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/pong2.berlios/
TERMUX_PKG_DESCRIPTION="A Three Dimensional Pong Game"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://download.sourceforge.net/pong2.berlios/pong2-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=7b3601b35a4f2d64e2a4e85b9d6ad2fe84a79d40a39be2909f3e52b094307639
TERMUX_PKG_DEPENDS="glu, libc++, opengl, openssl, sdl, sdl-image"
TERMUX_PKG_GROUPS="games"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	cp $TERMUX_PREFIX/share/aclocal/sdl.m4 m4/
	autoreconf -fi

	CPPFLAGS+=" -I$TERMUX_PREFIX/include/SDL"
}

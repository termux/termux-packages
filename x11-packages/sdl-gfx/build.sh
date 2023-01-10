TERMUX_PKG_HOMEPAGE=https://www.ferzkopp.net/wordpress/2016/01/02/sdl_gfx-sdl2_gfx/
TERMUX_PKG_DESCRIPTION="SDL-1.2 graphics drawing primitives, rotozoom and other supporting functions"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.26
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.ferzkopp.net/Software/SDL_gfx-2.0/SDL_gfx-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7ceb4ffb6fc63ffba5f1290572db43d74386cd0781c123bc912da50d34945446
TERMUX_PKG_DEPENDS="sdl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-mmx
"

termux_step_pre_configure() {
	cp $TERMUX_PREFIX/share/aclocal/sdl.m4 m4/
	autoreconf -fi

	CPPFLAGS+=" -I$TERMUX_PREFIX/include/SDL"
}

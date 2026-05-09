TERMUX_PKG_HOMEPAGE=https://github.com/pjasicek/OpenClaw
TERMUX_PKG_DESCRIPTION="Open source re-implementation of Captain Claw (1997) game"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@aishwaryapasde-max"
TERMUX_PKG_VERSION=1.03
TERMUX_PKG_SRCURL=https://github.com/pjasicek/OpenClaw/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8b6c210a5ab1235aa8da6639a55f352e3b9c9e0b7a404628b4c1f61d7c3a0885
TERMUX_PKG_DEPENDS="sdl2, sdl2-image, sdl2-mixer, sdl2-ttf, libpng, zlib"
TERMUX_PKG_BUILD_DEPENDS="cmake, make, clang"
TERMUX_PKG_BUILD_IN_SRC=false

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_SYSTEM_NAME=Linux
		-DUSE_SDL2=ON
	"
}

termux_step_make() {
	cd $TERMUX_PKG_BUILDDIR
	make -j$TERMUX_PKG_MAKE_PROCESSES
}

termux_step_make_install() {
	cd $TERMUX_PKG_BUILDDIR
	make install
}

TERMUX_PKG_HOMEPAGE=https://github.com/pjasicek/OpenClaw
TERMUX_PKG_DESCRIPTION="Open source re-implementation of Captain Claw (1997) platformer game"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@aishwaryapasde-max"
TERMUX_PKG_VERSION=1.03
TERMUX_PKG_SRCURL=https://github.com/pjasicek/OpenClaw/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8b6c210a5ab1235aa8da6639a55f352e3b9c9e0b7a404628b4c1f61d7c3a0885
TERMUX_PKG_DEPENDS="sdl2, sdl2-image, sdl2-mixer, sdl2-ttf, libpng, zlib"
TERMUX_PKG_BUILD_DEPENDS="cmake, make, clang"
TERMUX_PKG_BUILD_IN_SRC=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_BUILD_TYPE=Release -DUSE_SDL2=ON"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/OpenClaw
}

termux_step_make_install() {
	install -Dm700 $TERMUX_PKG_BUILDDIR/openclaw $TERMUX_PREFIX/bin/openclaw
	install -Dm600 $TERMUX_PKG_SRCDIR/../LICENSE.txt $TERMUX_PREFIX/share/doc/openclaw-game/LICENSE
	
	# Create game data directory
	mkdir -p $TERMUX_PREFIX/share/openclaw-game
	
	# Install launcher with controller and save state support
	install -Dm700 $TERMUX_PKG_BUILDER_DIR/openclaw-game-launcher $TERMUX_PREFIX/bin/openclaw-game
}

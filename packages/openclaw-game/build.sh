TERMUX_PKG_HOMEPAGE=https://github.com/pjasicek/OpenClaw
TERMUX_PKG_DESCRIPTION="Open source re-implementation of Captain Claw (1997) platformer game"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@aishwaryapasde-max"
TERMUX_PKG_VERSION=1.03
TERMUX_PKG_SRCURL=https://github.com/pjasicek/OpenClaw/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8b6c210a5ab1235aa8da6639a55f352e3b9c9e0b7a404628b4c1f61d7c3a0885
TERMUX_PKG_DEPENDS="sdl2, sdl2-image, sdl2-mixer, sdl2-ttf, libpng, zlib"
TERMUX_PKG_BUILD_DEPENDS="cmake, make, clang"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	cd "$TERMUX_PKG_SRCDIR"
	mkdir -p build && cd build
	
	cmake ../OpenClaw \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX="$TERMUX_PREFIX" \
		-DCMAKE_SYSTEM_NAME=Linux \
		-DUSE_SDL2=ON \
		-DBUILD_SHARED_LIBS=OFF
}

termux_step_make() {
	cd "$TERMUX_PKG_SRCDIR/build"
	make -j$TERMUX_MAKE_PROCESSES
}

termux_step_make_install() {
	cd "$TERMUX_PKG_SRCDIR/build"
	install -Dm700 openclaw "$TERMUX_PREFIX/bin/openclaw"
	
	# Install launcher script
	install -Dm700 "$TERMUX_PKG_BUILDER_DIR/openclaw-game" "$TERMUX_PREFIX/bin/openclaw-game"
}

TERMUX_PKG_HOMEPAGE=https://github.com/pjasicek/OpenClaw
TERMUX_PKG_DESCRIPTION="OpenClaw - open source re-implementation of Captain Claw (1997) platformer game"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@aishwaryapasde-max"
TERMUX_PKG_VERSION=1.03
TERMUX_PKG_SRCURL=https://github.com/pjasicek/OpenClaw/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8b6c210a5ab1235aa8da6639a55f352e3b9c9e0b7a404628b4c1f61d7c3a0885
TERMUX_PKG_DEPENDS="sdl2, sdl2-image, sdl2-mixer, sdl2-ttf, libpng, zlib"
TERMUX_PKG_BUILD_DEPENDS="cmake, make, clang"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	# OpenClaw uses CMake in OpenClaw/ subdirectory
	mkdir -p build && cd build
	cmake ../OpenClaw \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX="$TERMUX_PREFIX" \
		-DCMAKE_SYSTEM_NAME=Linux \
		-DUSE_SDL2=ON
}

termux_step_make() {
	cd "$TERMUX_PKG_SRCDIR/build"
	make -j$TERMUX_MAKE_PROCESSES
}

termux_step_make_install() {
	cd "$TERMUX_PKG_SRCDIR/build"
	install -Dm700 openclaw "$TERMUX_PREFIX/bin/openclaw"
	
	# Create launcher
	mkdir -p "$TERMUX_PREFIX/share/openclaw-game"
	cat > "$TERMUX_PREFIX/bin/openclaw-game" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# OpenClaw Game Launcher
DATA_DIR="${1:-/sdcard/OpenClaw}"
if [ ! -f "$DATA_DIR/RE1.PAL" ]; then
    echo "Error: Game files not found!"
    echo "Copy original Claw files to: $DATA_DIR"
    echo "Required: RE1.PAL, LEVEL*.SVR"
    exit 1
fi
export SDL_VIDEODRIVER=x11
export DISPLAY=:1
cd "$DATA_DIR"
exec openclaw "$@"
EOF
	chmod 700 "$TERMUX_PREFIX/bin/openclaw-game"
}

termux_step_create_debscripts() {
	cat > postinst << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
echo ""
echo "╔════════════════════════════════════════╗"
echo "║     🎮 OpenClaw Game Installed!        ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "Place original Claw game files in:"
echo "  /sdcard/OpenClaw/"
echo ""
echo "Required: RE1.PAL, LEVEL*.SVR files"
echo ""
echo "Run: openclaw-game"
echo ""
EOF
}

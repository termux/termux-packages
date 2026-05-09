TERMUX_PKG_HOMEPAGE=https://github.com/aishwaryapasde-max/MobileClaw
TERMUX_PKG_DESCRIPTION="Run OpenClaw (Captain Claw) on Android via Termux - Easy installation and launcher"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@aishwaryapasde-max"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/aishwaryapasde-max/MobileClaw/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=SKIP_CHECKSUM
TERMUX_PKG_DEPENDS="git, cmake, make, clang, sdl2, sdl2-image, sdl2-mixer, sdl2-ttf, libpng, zlib, wget, unzip"
TERMUX_PKG_RECOMMENDS="termux-x11-nightly, virglrenderer-android"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=false

termux_step_make_install() {
	install -Dm700 "$TERMUX_PKG_SRCDIR/mobileclaw" "$TERMUX_PREFIX/bin/mobileclaw"
	install -Dm600 "$TERMUX_PKG_SRCDIR/install.sh" "$TERMUX_PREFIX/share/doc/mobileclaw/install.sh"
	install -Dm600 "$TERMUX_PKG_SRCDIR/README.md" "$TERMUX_PREFIX/share/doc/mobileclaw/README.md"
	install -Dm600 "$TERMUX_PKG_SRCDIR/LICENSE" "$TERMUX_PREFIX/share/doc/mobileclaw/LICENSE"
}

termux_step_create_debscripts() {
	cat > postinst << EOF
#!/data/data/com.termux/files/usr/bin/bash
echo ""
echo "╔════════════════════════════════════════╗"
echo "║     🎮 MobileClaw Installed! 🎮       ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "Quick Start:"
echo "  mobileclaw --help      Show help"
echo "  mobileclaw --install   Full setup"
echo "  mobileclaw --run       Run the game"
echo ""
EOF
}

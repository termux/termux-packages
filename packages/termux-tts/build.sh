TERMUX_PKG_HOMEPAGE="https://uno-km.vercel.app/lib/tts/"
TERMUX_PKG_DESCRIPTION="Kokoro 82M On-Device High-Speed Speech Synthesis CLI for Termux"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Uno Kim <contact@uno-km.com>"
TERMUX_PKG_VERSION="1.6.0"
TERMUX_PKG_SRCURL="https://github.com/uno-km/termux-tts/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="28440d7a57a100184913a9e93402a31aff6b9bab61865e760bab082e4c61f874"
TERMUX_PKG_DEPENDS="nodejs, python, libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=false

termux_step_make_install() {
	local _INSTALL_DIR="$TERMUX_PREFIX/lib/node_modules/termux-tts"
	mkdir -p "$_INSTALL_DIR"
	cp -r . "$_INSTALL_DIR/"
	mkdir -p "$TERMUX_PREFIX/bin"
	ln -sf "../lib/node_modules/termux-tts/bin/cli.js" "$TERMUX_PREFIX/bin/termux-tts"
	chmod 755 "$TERMUX_PREFIX/bin/termux-tts" 
}

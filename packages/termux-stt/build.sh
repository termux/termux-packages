TERMUX_PKG_HOMEPAGE="https://uno-km.vercel.app/lib/stt/"
TERMUX_PKG_DESCRIPTION="On-Device Speech-to-Text & Neural Diarization CLI (Whisper & Sherpa-ONNX)"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Uno Kim <contact@uno-km.com>"
TERMUX_PKG_VERSION="1.4.0"
TERMUX_PKG_SRCURL="https://github.com/uno-km/termux-stt/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="50987c5b7b45a07bc23c5560730eba7498b8c7776a03534869f2fa99ee243788"
TERMUX_PKG_DEPENDS="nodejs, python, libc++, libvulkan"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=false

termux_step_make_install() {
	local _INSTALL_DIR="$TERMUX_PREFIX/lib/node_modules/termux-stt"
	mkdir -p "$_INSTALL_DIR"
	cp -r . "$_INSTALL_DIR/"
	mkdir -p "$TERMUX_PREFIX/bin"
	ln -sf "../lib/node_modules/termux-stt/bin/cli.js" "$TERMUX_PREFIX/bin/termux-stt"
	ln -sf "../lib/node_modules/termux-stt/bin/termux-stt.js" "$TERMUX_PREFIX/bin/termux-stt-install"
	chmod 755 "$TERMUX_PREFIX/bin/termux-stt" "$TERMUX_PREFIX/bin/termux-stt-install" 
}

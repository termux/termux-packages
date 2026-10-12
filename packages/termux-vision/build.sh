TERMUX_PKG_HOMEPAGE="https://uno-km.vercel.app/lib/vision/"
TERMUX_PKG_DESCRIPTION="Moondream2 & LLaVA On-Device Multimodal Computer Vision CLI for Termux"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Uno Kim <contact@uno-km.com>"
TERMUX_PKG_VERSION="1.7.0"
TERMUX_PKG_SRCURL="https://github.com/uno-km/termux-vision/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="c6f833723e88cc0f51e430d361132d9e9c1958aeae090ca32667d6527d626f59"
TERMUX_PKG_DEPENDS="nodejs, python, libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=false

termux_step_make_install() {
	local _INSTALL_DIR="$TERMUX_PREFIX/lib/node_modules/termux-vision"
	mkdir -p "$_INSTALL_DIR"
	cp -r . "$_INSTALL_DIR/"
	mkdir -p "$TERMUX_PREFIX/bin"
	ln -sf "../lib/node_modules/termux-vision/bin/cli.js" "$TERMUX_PREFIX/bin/termux-vision"
	ln -sf "../lib/node_modules/termux-vision/bin/cli.js" "$TERMUX_PREFIX/bin/tv"
	chmod 755 "$TERMUX_PREFIX/bin/termux-vision" "$TERMUX_PREFIX/bin/tv" 
}

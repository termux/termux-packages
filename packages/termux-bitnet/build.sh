TERMUX_PKG_HOMEPAGE="https://uno-km.vercel.app/lib/bitnet/"
TERMUX_PKG_DESCRIPTION="BitNet 1.58-bit (i2_s) On-Device ARM NEON Inference Engine"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Uno Kim <contact@uno-km.com>"
TERMUX_PKG_VERSION="2.0.1"
TERMUX_PKG_SRCURL="https://github.com/uno-km/termux-bitnet/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="2775b29ed1e8312a53c31a95340d27df00b736d7ecac713ce028339c666c33dc"
TERMUX_PKG_DEPENDS="nodejs, python, libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=false

termux_step_make_install() {
	local _INSTALL_DIR="$TERMUX_PREFIX/lib/node_modules/termux-bitnet"
	mkdir -p "$_INSTALL_DIR"
	cp -r . "$_INSTALL_DIR/"
	mkdir -p "$TERMUX_PREFIX/bin"
	ln -sf "../lib/node_modules/termux-bitnet/bin/cli.js" "$TERMUX_PREFIX/bin/termux-bitnet"
	chmod 755 "$TERMUX_PREFIX/bin/termux-bitnet" 
}

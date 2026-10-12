TERMUX_PKG_HOMEPAGE="https://uno-km.vercel.app/lib/train/"
TERMUX_PKG_DESCRIPTION="On-Device Deep Learning & LoRA Fine-Tuning CLI Framework for Termux"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Uno Kim <contact@uno-km.com>"
TERMUX_PKG_VERSION="2.0.1"
TERMUX_PKG_SRCURL="https://github.com/uno-km/termux-train/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="b2751341a30f37ca7265a9cb3ebd991531dc7dd7849c50c06b5cdf47dee526d2"
TERMUX_PKG_DEPENDS="nodejs, python, libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=false

termux_step_make_install() {
	local _INSTALL_DIR="$TERMUX_PREFIX/lib/node_modules/termux-train"
	mkdir -p "$_INSTALL_DIR"
	cp -r . "$_INSTALL_DIR/"
	mkdir -p "$TERMUX_PREFIX/bin"
	ln -sf "../lib/node_modules/termux-train/bin/cli.js" "$TERMUX_PREFIX/bin/termux-train"
	ln -sf "../lib/node_modules/termux-train/bin/cli.js" "$TERMUX_PREFIX/bin/tt"
	chmod 755 "$TERMUX_PREFIX/bin/termux-train" "$TERMUX_PREFIX/bin/tt" 
}

TERMUX_PKG_HOMEPAGE="https://uno-km.vercel.app/lib/diffusion/"
TERMUX_PKG_DESCRIPTION="AmfyUI DAG Studio & Z-Image Turbo (6.0B DiT) On-Device Diffusion CLI"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Uno Kim <contact@uno-km.com>"
TERMUX_PKG_VERSION="2.0.1"
TERMUX_PKG_SRCURL="https://github.com/uno-km/termux-diffusion/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="6fac42b68ea086117d5e8c9d5d25aa4ad83ae5a0836d3f6509719c3d933a84ff"
TERMUX_PKG_DEPENDS="nodejs, python, libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=false

termux_step_make_install() {
	local _INSTALL_DIR="$TERMUX_PREFIX/lib/node_modules/termux-diffusion"
	mkdir -p "$_INSTALL_DIR"
	cp -r . "$_INSTALL_DIR/"
	mkdir -p "$TERMUX_PREFIX/bin"
	ln -sf "../lib/node_modules/termux-diffusion/bin/cli.js" "$TERMUX_PREFIX/bin/termux-diffusion"
	chmod 755 "$TERMUX_PREFIX/bin/termux-diffusion" 
}

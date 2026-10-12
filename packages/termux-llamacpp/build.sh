TERMUX_PKG_HOMEPAGE="https://uno-km.vercel.app/lib/llamacpp/"
TERMUX_PKG_DESCRIPTION="GGUF Universal LLM Runtime, Model Manager & OpenAI Server for Termux"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Uno Kim <contact@uno-km.com>"
TERMUX_PKG_VERSION="1.4.0"
TERMUX_PKG_SRCURL="https://github.com/uno-km/termux-llamacpp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="5822233b3322cff0f057dc2e53413261f89c023c3e7d0c21f3ae95bbbd50a0b7"
TERMUX_PKG_DEPENDS="nodejs, python, libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=false

termux_step_make_install() {
	local _INSTALL_DIR="$TERMUX_PREFIX/lib/node_modules/termux-llamacpp"
	mkdir -p "$_INSTALL_DIR"
	cp -r . "$_INSTALL_DIR/"
	mkdir -p "$TERMUX_PREFIX/bin"
	ln -sf "../lib/node_modules/termux-llamacpp/bin/cli.js" "$TERMUX_PREFIX/bin/termux-llama"
	ln -sf "../lib/node_modules/termux-llamacpp/bin/cli.js" "$TERMUX_PREFIX/bin/termux-llamacpp"
	chmod 755 "$TERMUX_PREFIX/bin/termux-llama" "$TERMUX_PREFIX/bin/termux-llamacpp" 
}

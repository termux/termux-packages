TERMUX_PKG_HOMEPAGE=https://emscripten.org/
TERMUX_PKG_DESCRIPTION="Emscripten is a complete compiler toolchain to WebAssembly"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.0.8
TERMUX_PKG_SRCURL=https://github.com/emscripten-core/emsdk/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=248d716dbe2e2424ee3f205c41024b4efde974e8987f2204a97edb315c588ff3
TERMUX_PKG_DEPENDS="llvm"
TERMUX_PKG_BUILD_DEPENDS="python3, node, java"

termux_step_pre_configure() {
	apt install -y python3
}

termux_step_make() {
    ./emsdk install latest
  
}

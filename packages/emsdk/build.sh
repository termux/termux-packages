TERMUX_PKG_HOMEPAGE=https://emscripten.org/
TERMUX_PKG_DESCRIPTION="Emscripten is a complete compiler toolchain to WebAssembly"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.0.8
TERMUX_PKG_SRCURL=https://github.com/emscripten-core/emsdk/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=248d716dbe2e2424ee3f205c41024b4efde974e8987f2204a97edb315c588ff3
TERMUX_PKG_DEPENDS="llvm"
TERMUX_PKG_BUILD_IN_SOURCE=true

termux_step_post_get_source() {
	./emsdk install latest 
	./emsdk activate latest 	
}

termux_step_make_instal() {
	rm $TERMUX_PREFIX/lib/emsdk -rf
	mv . $TERMUX_PREFIX/lib/emsdk 
}

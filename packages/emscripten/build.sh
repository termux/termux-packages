TERMUX_PKG_HOMEPAGE=https://emscripten.org/
TERMUX_PKG_DESCRIPTION="Emscripten is a complete compiler toolchain to WebAssembly"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.0.9
TERMUX_PKG_SRCURL=https://github.com/emscripten-core/emscripten/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9e54b33da5025270221b38fdc603191b8f22afa038b72c6dcfaa6423888746f5
TERMUX_PKG_DEPENDS="python, llvm, nodejs, binaryen"

termux_step_post_get_source() { 
	export EM_BINARYEN_ROOT=$TERMUX_PREFIX/bin
	./emcc -v
}

termux_step_make_install() {
	rm $TERMUX_PREFIX/bin/emscripten -rf
	mkdir $TERMUX_PREFIX/bin/emscripten
	cp -r $TERMUX_PKG_SRCDIR/{emcc,emcc.py,emscripten.py,tools} $TERMUX_PREFIX/bin/emscripten
}

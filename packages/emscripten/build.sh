TERMUX_PKG_HOMEPAGE=https://emscripten.org/
TERMUX_PKG_DESCRIPTION="Emscripten is a complete compiler toolchain to WebAssembly"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.0.9
TERMUX_PKG_SRCURL=https://github.com/emscripten-core/emscripten/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9e54b33da5025270221b38fdc603191b8f22afa038b72c6dcfaa6423888746f5
TERMUX_PKG_DEPENDS="python, llvm, nodejs, binaryen"

termux_step_post_get_source() { 
	./emcc -v
}

termux_step_make_install() {
	rm $TERMUX_PREFIX/bin/emscripten -rf
	mkdir $TERMUX_PREFIX/bin/emscripten
	cp $TERMUX_PKG_SRCDIR/emcc $TERMUX_PREFIX/bin/emscripten/emcc
	cp $TERMUX_PKG_SRCDIR/emcc.py $TERMUX_PREFIX/bin/emscripten/emcc.py
	cp $TERMUX_PKG_SRCDIR/emscripten.py $TERMUX_PREFIX/bin/emscripten/emscripten.py
	cp -r $TERMUX_PKG_SRCDIR/tools $TERMUX_PREFIX/bin/emscripten/tools
}

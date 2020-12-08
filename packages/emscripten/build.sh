TERMUX_PKG_HOMEPAGE=https://emscripten.org/
TERMUX_PKG_DESCRIPTION="Emscripten is a complete compiler toolchain to WebAssembly"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.0.9
TERMUX_PKG_SRCURL=https://github.com/emscripten-core/emscripten/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9e54b33da5025270221b38fdc603191b8f22afa038b72c6dcfaa6423888746f5
TERMUX_PKG_DEPENDS="python, nodejs, binaryen"
TERMUX_PKG_BUILD_DEPENDS="cmake"

LLVM_COMMIT_HASH=a1cb9cbf5c4939e78a6c3b3677cf8e3dbdf51932
LLVM_CHECKSUM=1f2a4e3ec2b21f676556305fe15de4130c027aa561512a8bc2c363907e5455f4

termux_step_post_get_source() { 
	termux_download https://github.com/llvm/llvm-project/archive/$LLVM_COMMIT_HASH.zip $TERMUX_PKG_CACHEDIR/llvm.zip $LLVM_CHECKSUM
	unzip $TERMUX_PKG_CACHEDIR/llvm.zip -d $TERMUX_PKG_CACHEDIR/llvm
	ls $TERMUX_PKG_CACHEDIR
	cd $TERMUX_PKG_CACHEDIR/llvm
	export LLVM_TARGET_ARCH
	if [ $TERMUX_ARCH = "arm" ]; then
		LLVM_TARGET_ARCH=ARM
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		LLVM_TARGET_ARCH=AArch64
	elif [ $TERMUX_ARCH = "i686" ]; then
		LLVM_TARGET_ARCH=X86
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		LLVM_TARGET_ARCH=X86
	else
		termux_error_exit "Invalid arch: $TERMUX_ARCH"
	fi
	cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGET_ARCH=$LLVM_TARGET_ARCH -DLLVM_ENABLE_PROJECTS='lld;clang' -DLLVM_TARGETS_TO_BUILD="host;WebAssembly" -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF
	cmake --build .
	export EM_LLVM_ROOT=$TERMUX_PKG_CACHEDIR/llvm/bin
	export EM_BINARYEN_ROOT=$TERMUX_PREFIX/bin
	./emcc -v
}

termux_step_make_install() {
	rm $TERMUX_PREFIX/bin/emscripten -rf
	mkdir $TERMUX_PREFIX/bin/emscripten
	cp -r $TERMUX_PKG_SRCDIR/{emcc,emcc.py,emscripten.py,tools, .emscripten} $TERMUX_PREFIX/bin/emscripten
}

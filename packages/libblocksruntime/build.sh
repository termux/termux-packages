TERMUX_PKG_HOMEPAGE=https://compiler-rt.llvm.org
TERMUX_PKG_DESCRIPTION="Blocks Runtime library"
TERMUX_PKG_LICENSE="NCSA"
# Should ideally match libllvm's version
TERMUX_PKG_VERSION=9.0.1
TERMUX_PKG_SRCURL=https://github.com/llvm/llvm-project/releases/download/llvmorg-${TERMUX_PKG_VERSION}/compiler-rt-${TERMUX_PKG_VERSION}.src.tar.xz
TERMUX_PKG_SHA256=c2bfab95c9986318318363d7f371a85a95e333bc0b34fbfa52edbd3f5e3a9077
TERMUX_PKG_BUILD_IN_SRC=true
shlibver=1

termux_step_configure() {
	# Stop CMake from being installed
	:
}

termux_step_make() {
	# Based on https://raw.githubusercontent.com/mackyle/blocksruntime/master/buildlib, with Fedora changes
	local LIB=libBlocksRuntime.a
	local SRC=BlocksRuntime

	cd "$TERMUX_PKG_SRCDIR/lib"
	cp "$TERMUX_PKG_BUILDER_DIR/config.h" "$TERMUX_PKG_SRCDIR/lib/config.h"
	"$CC" -c -fPIC $CFLAGS -o "$SRC/data.o" "$SRC/data.c"
	"$CC" -c -fPIC $CFLAGS -o "$SRC/runtime.o" -I . "$SRC/runtime.c"
	# Static
	"$AR" cr "$LIB" "$SRC/data.o" "$SRC/runtime.o"
	"$RANLIB" "$LIB"
	# Shared
	"$CC" -fPIC $CFLAGS -o "${LIB%.a}.so.0.$shlibver" -s -shared "-Wl,-soname,${LIB%.a}.so.0" -Wl,-whole-archive "$LIB" -Wl,-no-whole-archive
}

termux_step_make_install() {
	install -Dm600 -t "$TERMUX_PREFIX/include" lib/BlocksRuntime/Block.h
	install -Dm600 -t "$TERMUX_PREFIX/include" lib/BlocksRuntime/Block_private.h
	install -Dm600 -t "$TERMUX_PREFIX/lib" lib/libBlocksRuntime.a
	install -Dm600 -t "$TERMUX_PREFIX/lib" "lib/libBlocksRuntime.so.0.$shlibver"
	ln -fs "libBlocksRuntime.so.0.$shlibver" "$TERMUX_PREFIX/lib/libBlocksRuntime.so.0"
	ln -fs libBlocksRuntime.so.0 "$TERMUX_PREFIX/lib/libBlocksRuntime.so"
}

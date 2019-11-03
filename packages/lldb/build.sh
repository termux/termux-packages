TERMUX_PKG_HOMEPAGE=https://lldb.llvm.org
TERMUX_PKG_DESCRIPTION="LLVM based debugger"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_VERSION=9.0.0
TERMUX_PKG_SRCURL=https://releases.llvm.org/$TERMUX_PKG_VERSION/lldb-$TERMUX_PKG_VERSION.src.tar.xz
TERMUX_PKG_SHA256=1e4c2f6a1f153f4b8afa2470d2e99dab493034c1ba8b7ffbbd7600de016d0794
TERMUX_PKG_REVISION=1
TERMUX_PKG_DEPENDS="libc++, libedit, libllvm, libxml2, ncurses-ui-libs"
TERMUX_PKG_BUILD_DEPENDS="libllvm-static"
TERMUX_PKG_BREAKS="lldb-dev, lldb-static"
TERMUX_PKG_REPLACES="lldb-dev, lldb-static"
TERMUX_PKG_HAS_DEBUG=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLLDB_DISABLE_CURSES=0
-DLLDB_DISABLE_LIBEDIT=0
-DLLDB_DISABLE_PYTHON=1
-DLLVM_CONFIG=$TERMUX_PREFIX/bin/llvm-config
-DLLVM_ENABLE_TERMINFO=1
-DLLVM_LINK_LLVM_DYLIB=ON
-DLLVM_DIR=$TERMUX_PREFIX/lib/cmake/llvm
-DClang_DIR=$TERMUX_PREFIX/lib/cmake/clang
-DLLVM_NATIVE_BUILD=$TERMUX_PREFIX/bin
"
termux_step_pre_configure() {
	cd $TERMUX_PKG_TMPDIR
	termux_download https://its-pointless.github.io/tblgen-llvm-lldb-9.tar.xz tblgen-llvm-lldb-9.tar.xz \
		0022ca75adeeda6c87f0fde352888e7a55747de05bc93035c2172535bb35f6c5
	tar xvf tblgen-llvm-lldb-9.tar.xz
	mv llvm-tblgen $TERMUX_PREFIX/bin
	PATH=$PATH:$TERMUX_PKG_TMPDIR
	if [ $TERMUX_ARCH = "x86_64" ]; then
		export LD_LIBRARY_PATH=/lib/x86_64-linux-gnu/
	fi
	touch $TERMUX_PREFIX/bin/clang-import-test
}

termux_step_post_make_install() {
	cp $TERMUX_PKG_SRCDIR/docs/lldb.1 $TERMUX_PREFIX/share/man/man1
	rm -f  $TERMUX_PREFIX/bin/llvm-tblgen $TERMUX_PREFIX/bin/clang-import-test
}

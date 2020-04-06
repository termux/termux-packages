TERMUX_PKG_HOMEPAGE=https://lldb.llvm.org
TERMUX_PKG_DESCRIPTION="LLVM based debugger"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_VERSION=9.0.1
TERMUX_PKG_SRCURL=https://github.com/llvm/llvm-project/releases/download/llvmorg-$TERMUX_PKG_VERSION/lldb-$TERMUX_PKG_VERSION.src.tar.xz
TERMUX_PKG_SHA256=8a7b9fd795c31a3e3cba6ce1377a2ae5c67376d92888702ce27e26f0971beb09
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
	termux_download https://its-pointless.github.io/tblgen-llvm-lldb-9.0.1.tar.xz tblgen-llvm-lldb-9.0.1.tar.xz \
		9cfd0aa3d9988e66838d4390ea9b2f701d1d8c87c44e226e10b8afd42c004622
	tar xvf tblgen-llvm-lldb-9.0.1.tar.xz
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

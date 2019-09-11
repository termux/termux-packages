TERMUX_PKG_HOMEPAGE=https://lldb.llvm.org
TERMUX_PKG_DESCRIPTION="LLVM based debugger"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_VERSION=8.0.1
TERMUX_PKG_SRCURL=https://github.com/llvm/llvm-project/releases/download/llvmorg-$TERMUX_PKG_VERSION/lldb-$TERMUX_PKG_VERSION.src.tar.xz
TERMUX_PKG_SHA256=e8a79baa6d11dd0650ab4a1b479f699dfad82af627cbbcd49fa6f2dc14e131d7
TERMUX_PKG_DEPENDS="libc++, libedit, libllvm, libxml2, ncurses-ui-libs"
TERMUX_PKG_BREAKS="lldb-dev"
TERMUX_PKG_REPLACES="lldb-dev"
TERMUX_PKG_HAS_DEBUG=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLLDB_DISABLE_CURSES=0
-DLLDB_DISABLE_LIBEDIT=0
-DLLDB_DISABLE_PYTHON=1
-DLLVM_CONFIG=$TERMUX_PREFIX/bin/llvm-config
-DLLVM_ENABLE_TERMINFO=1
-DLLVM_LINK_LLVM_DYLIB=ON
"

# Can't be compiled for x86_64 due to 'llvm-tblgen' error.
TERMUX_PKG_BLACKLISTED_ARCHES="x86_64"

termux_step_pre_configure() {
	LDFLAGS+=" -Wl,--exclude-libs=libLLVMSupport.a"
}

termux_step_post_make_install() {
	cp $TERMUX_PKG_SRCDIR/docs/lldb.1 $TERMUX_PREFIX/share/man/man1
}

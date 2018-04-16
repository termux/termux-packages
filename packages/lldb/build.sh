TERMUX_PKG_HOMEPAGE=https://lldb.llvm.org
TERMUX_PKG_DESCRIPTION="lldb debugger"
TERMUX_PKG_VERSION=6.0.0
TERMUX_PKG_SRCURL=http://releases.llvm.org/${TERMUX_PKG_VERSION}/lldb-$TERMUX_PKG_VERSION.src.tar.xz
TERMUX_PKG_SHA256=46f54c1d7adcd047d87c0179f7b6fa751614f339f4f87e60abceaa45f414d454
TERMUX_PKG_DEPENDS="libedit, libllvm"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" -DLLVM_CONFIG=$TERMUX_PREFIX/bin/llvm-config \
-DLLDB_DISABLE_LIBEDIT=0 \
-DLLDB_DISABLE_CURSES=0 \
-DLLDB_DISABLE_PYTHON=1 \
-DLLVM_ENABLE_TERMINFO=1"
termux_step_pre_configure() {
	LDFLAGS+=" -Wl,--exclude-libs=ALL"
}
termux_step_post_make_install() {
	cp $TERMUX_PKG_SRCDIR/docs/lldb.1 $TERMUX_PREFIX/share/man/man1
}

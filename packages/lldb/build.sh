TERMUX_PKG_HOMEPAGE=https://lldb.llvm.org
TERMUX_PKG_DESCRIPTION="LLVM based debugger"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_VERSION=10.0.1
TERMUX_PKG_SRCURL=(https://github.com/llvm/llvm-project/releases/download/llvmorg-$TERMUX_PKG_VERSION/lldb-$TERMUX_PKG_VERSION.src.tar.xz
		   https://github.com/llvm/llvm-project/releases/download/llvmorg-$TERMUX_PKG_VERSION/llvm-$TERMUX_PKG_VERSION.src.tar.xz)
TERMUX_PKG_SHA256=(07abe87c25876aa306e73127330f5f37d270b6b082d50cc679e31b4fc02a3714
		   c5d8e30b57cbded7128d78e5e8dad811bff97a8d471896812f57fa99ee82cdf3)
TERMUX_PKG_DEPENDS="libc++, libedit, libllvm, libxml2, ncurses-ui-libs"
TERMUX_PKG_BUILD_DEPENDS="libllvm-static"
TERMUX_PKG_BREAKS="lldb-dev, lldb-static"
TERMUX_PKG_REPLACES="lldb-dev, lldb-static"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_HAS_DEBUG=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLLDB_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/lldb-tblgen
-DLLVM_ENABLE_SPHINX=ON
-DLLVM_ENABLE_TERMINFO=1
-DLLVM_LINK_LLVM_DYLIB=ON
-DLLVM_DIR=$TERMUX_PREFIX/lib/cmake/llvm
-DLLVM_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/llvm/bin/llvm-tblgen
"

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	mkdir llvm
	cd llvm

	cmake -G Ninja $TERMUX_PKG_SRCDIR/llvm-${TERMUX_PKG_VERSION}.src
	ninja -j $TERMUX_MAKE_PROCESSES llvm-tblgen

	cd ..
	cmake -G Ninja $TERMUX_PKG_SRCDIR -DLLDB_INCLUDE_TESTS=OFF \
	-DLLVM_DIR=$TERMUX_PKG_HOSTBUILD_DIR/llvm/lib/cmake/llvm
	ninja -j $TERMUX_MAKE_PROCESSES lldb-tblgen
}

termux_step_make() {
	ninja -w dupbuild=warn -j $TERMUX_MAKE_PROCESSES all docs-lldb-man
}

termux_step_post_make_install() {
	cp $TERMUX_PKG_BUILDDIR/docs/man/lldb.1 $TERMUX_PREFIX/share/man/man1
}

TERMUX_PKG_HOMEPAGE=https://lldb.llvm.org
TERMUX_PKG_DESCRIPTION="LLVM based debugger"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_VERSION=10.0.0
TERMUX_PKG_SRCURL=(https://github.com/llvm/llvm-project/releases/download/llvmorg-$TERMUX_PKG_VERSION/lldb-$TERMUX_PKG_VERSION.src.tar.xz
		   https://github.com/llvm/llvm-project/releases/download/llvmorg-$TERMUX_PKG_VERSION/llvm-$TERMUX_PKG_VERSION.src.tar.xz)
TERMUX_PKG_SHA256=(dd1ffcb42ed033f5167089ec4c6ebe84fbca1db4a9eaebf5c614af09d89eb135
		   df83a44b3a9a71029049ec101fb0077ecbbdf5fe41e395215025779099a98fdf)
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

termux_step_pre_configure() {
	# This will be there if libllvm was built from scratch, but not if the pre-built
	# package was extracted. Not really needed but the stupid clang CMake config makes
	# sure it's there.
	if [ ! -f "$TERMUX_PREFIX/bin/clang-import-test" ]; then
		touch $TERMUX_PREFIX/bin/clang-import-test
		touch $TERMUX_PKG_BUILDDIR/rm-fake-ci-test
	fi
}

termux_step_make() {
	ninja -w dupbuild=warn -j $TERMUX_MAKE_PROCESSES all docs-lldb-man
}

termux_step_post_make_install() {
	cp $TERMUX_PKG_BUILDDIR/docs/man/lldb.1 $TERMUX_PREFIX/share/man/man1
	if [ -f "$TERMUX_PKG_BUILDDIR/rm-fake-ci-test" ]; then
		rm $TERMUX_PREFIX/bin/clang-import-test
	fi
}

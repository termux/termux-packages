TERMUX_PKG_HOMEPAGE=http://llvm.org
TERMUX_PKG_DESCRIPTION='Low Level Virtual Machine'
TERMUX_PKG_VERSION=3.9.1
_BASE_SRCURL=http://llvm.org/releases/${TERMUX_PKG_VERSION}
TERMUX_PKG_SRCURL=$_BASE_SRCURL/llvm-${TERMUX_PKG_VERSION}.src.tar.xz
TERMUX_PKG_SHA256=1fd90354b9cf19232e8f168faf2220e79be555df3aa743242700879e8fd329ee
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="binutils, ncurses, ndk-sysroot, ndk-stl, libgcc, libffi, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DLLVM_ENABLE_PIC=ON -DLLVM_BUILD_TESTS=OFF
-DLLVM_INCLUDE_TESTS=OFF -DLLVM_LINK_LLVM_DYLIB=ON -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_BUILD_TOOLS=OFF
-DLLVM_BUILD_EXAMPLES=OFF -DLLVM_ENABLE_EH=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_FFI=ON
-DPYTHON_EXECUTABLE=`which python2` -DLLDB_DISABLE_PYTHON=ON -DCLANG_INCLUDE_TESTS=OFF
-DCLANG_TOOL_C_INDEX_TEST_BUILD=OFF -DLLDB_DISABLE_LIBEDIT=ON -D__ANDROID_NDK__=True -DANDROID=True"
TERMUX_PKG_FORCE_CMAKE=yes

termux_step_post_extract_package () {
	CLANG_SRC_TAR=cfe-${TERMUX_PKG_VERSION}.src.tar.xz
	LLDB_SRC_TAR=lldb-${TERMUX_PKG_VERSION}.src.tar.xz
	LIBUNWIND_SRC_TAR=libunwind-${TERMUX_PKG_VERSION}.src.tar.xz
	test ! -f $TERMUX_PKG_CACHEDIR/$CLANG_SRC_TAR && termux_download $_BASE_SRCURL/$CLANG_SRC_TAR \
                $TERMUX_PKG_CACHEDIR/$CLANG_SRC_TAR e6c4cebb96dee827fa0470af313dff265af391cb6da8d429842ef208c8f25e63
	test ! -f $TERMUX_PKG_CACHEDIR/$LLDB_SRC_TAR && termux_download $_BASE_SRCURL/$LLDB_SRC_TAR \
                $TERMUX_PKG_CACHEDIR/$LLDB_SRC_TAR 7e3311b2a1f80f4d3426e09f9459d079cab4d698258667e50a46dccbaaa460fc
	test ! -f $TERMUX_PKG_CACHEDIR/$LIBUNWIND_SRC_TAR && termux_download $_BASE_SRCURL/$LIBUNWIND_SRC_TAR \
		$TERMUX_PKG_CACHEDIR/$LIBUNWIND_SRC_TAR 0b0bc73264d7ab77d384f8a7498729e3c4da8ffee00e1c85ad02a2f85e91f0e6

	cd $TERMUX_PKG_SRCDIR

        tar -xf $TERMUX_PKG_CACHEDIR/$CLANG_SRC_TAR -C tools
        mv tools/cfe-${TERMUX_PKG_VERSION}.src tools/clang
	tar -xf $TERMUX_PKG_CACHEDIR/$LLDB_SRC_TAR -C tools
        mv tools/lldb-${TERMUX_PKG_VERSION}.src tools/lldb
	tar -xf $TERMUX_PKG_CACHEDIR/$LIBUNWIND_SRC_TAR -C tools
	mv tools/libunwind-${TERMUX_PKG_VERSION}.src tools/libunwind
}

termux_step_host_build () {
        cmake -G "Unix Makefiles" $TERMUX_PKG_SRCDIR \
                -DLLVM_BUILD_TESTS=OFF \
                -DLLVM_INCLUDE_TESTS=OFF \
		-DLLVM_TARGETS_TO_BUILD=X86 \
		-DLLVM_BUILD_TOOLS=OFF \
		-DLLVM_BUILD_EXAMPLES=OFF \
		-DLLVM_INCLUDE_EXAMPLES=OFF \
		-DLLVM_ENABLE_ASSERTIONS=OFF \
		-DLLVM_ENABLE_PIC=OFF \
		-DLLVM_ENABLE_ZLIB=OFF \
		-DLLVM_OPTIMIZED_TABLEGEN=ON
        make -j $TERMUX_MAKE_PROCESSES llvm-tblgen clang-tblgen
}

termux_step_pre_configure () {
	LLVM_DEFAULT_TARGET_TRIPLE=$TERMUX_HOST_PLATFORM
	if [ $TERMUX_ARCH = "arm" ]; then
		LLVM_TARGET_ARCH=ARM
		# See https://github.com/termux/termux-packages/issues/282
		LLVM_DEFAULT_TARGET_TRIPLE="armv7a-linux-androideabi"
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		LLVM_TARGET_ARCH=AArch64
	elif [ $TERMUX_ARCH = "i686" ]; then
		LLVM_TARGET_ARCH=X86
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		LLVM_TARGET_ARCH=X86
	else
		echo "Invalid arch: $TERMUX_ARCH"
		exit 1
	fi

	CXXFLAGS="$CXXFLAGS -D__ANDROID_NDK__ -DANDROID"

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/llvm-tblgen
                -DLLVM_DEFAULT_TARGET_TRIPLE=$LLVM_DEFAULT_TARGET_TRIPLE -DLLVM_TARGET_ARCH=$LLVM_TARGET_ARCH
                -DLLVM_TARGETS_TO_BUILD=$LLVM_TARGET_ARCH -DCLANG_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/clang-tblgen
		-DC_INCLUDE_DIRS=$TERMUX_PREFIX/include"
		#-DHAVE_UNWIND_BACKTRACE=False" # arm has two conflicting defs for __Unwind_Ptr
}

termux_step_make_install () {
	create_file_lists

        cd $TERMUX_PKG_BUILDDIR
	make install
}

# this function creates file_lists for subpackages
create_file_lists () {
	mkdir $TERMUX_PKG_BUILDDIR/../{lldb,clang,libunwind}
        make -C tools/lldb DESTDIR="$TERMUX_PKG_BUILDDIR/../lldb" install
        make -C tools/clang DESTDIR="$TERMUX_PKG_BUILDDIR/../clang" install
	make -C tools/libunwind DESTDIR="$TERMUX_PKG_BUILDDIR/../libunwind" install
        cd "$TERMUX_PKG_BUILDDIR/../lldb$TERMUX_PREFIX"
        find * -type f > "$TERMUX_PKG_BUILDDIR/file_list_lldb.txt"
        cd "$TERMUX_PKG_BUILDDIR/../clang$TERMUX_PREFIX"
        find * -type f > "$TERMUX_PKG_BUILDDIR/file_list_clang.txt"
	cd "$TERMUX_PKG_BUILDDIR/../libunwind$TERMUX_PREFIX"
	find * -type f > "$TERMUX_PKG_BUILDDIR/file_list_libunwind.txt"
        rm -r $TERMUX_PKG_BUILDDIR/../{lldb,clang,libunwind}
}

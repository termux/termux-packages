TERMUX_PKG_HOMEPAGE=http://clang.llvm.org/
TERMUX_PKG_DESCRIPTION="C and C++ frontend for the LLVM compiler"
_PKG_MAJOR_VERSION=3.6
TERMUX_PKG_VERSION=${_PKG_MAJOR_VERSION}.1
TERMUX_PKG_SRCURL=http://llvm.org/releases/${TERMUX_PKG_VERSION}/llvm-${TERMUX_PKG_VERSION}.src.tar.xz
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_RM_AFTER_INSTALL="bin/macho-dump bin/bugpoint bin/llvm-tblgen lib/BugpointPasses.so lib/LLVMHello.so"
TERMUX_PKG_DEPENDS="libgnustl, ncurses, ndk-sysroot"

termux_step_post_extract_package () {
	CLANG_SRC_TAR=cfe-${TERMUX_PKG_VERSION}.src.tar.xz
	test ! -f $TERMUX_PKG_CACHEDIR/$CLANG_SRC_TAR && curl http://llvm.org/releases/${TERMUX_PKG_VERSION}/$CLANG_SRC_TAR > $TERMUX_PKG_CACHEDIR/$CLANG_SRC_TAR

	cd $TERMUX_PKG_SRCDIR
	tar -xf $TERMUX_PKG_CACHEDIR/$CLANG_SRC_TAR -C tools
	mv tools/cfe-${TERMUX_PKG_VERSION}.src tools/clang
}

termux_step_host_build () {
	cmake -G "Unix Makefiles" $TERMUX_PKG_SRCDIR
	make -j $TERMUX_MAKE_PROCESSES V=1
}

termux_step_configure () {
	CXXFLAGS+=" -fno-devirtualize" # Avoid hitting https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61659

	cd $TERMUX_PKG_BUILDDIR
        LLVM_DEFAULT_TARGET_TRIPLE=$TERMUX_HOST_PLATFORM
        LLVM_TARGET_ARCH=$TERMUX_ARCH
        if [ $TERMUX_ARCH = "arm" ]; then
                LLVM_TARGET_ARCH=ARM
                LLVM_DEFAULT_TARGET_TRIPLE="armv7a-linux-androideabihf"
        elif [ $TERMUX_ARCH = "i686" ]; then
                LLVM_TARGET_ARCH=X86
        fi
        # see CMakeLists.txt and tools/clang/CMakeLists.txt
	cmake -G "Unix Makefiles" .. \
		-DCMAKE_AR=`which ${TERMUX_HOST_PLATFORM}-ar` \
                -DCMAKE_BUILD_TYPE=MinSizeRel \
		-DCMAKE_CROSSCOMPILING=True \
		-DCMAKE_CXX_FLAGS="$CXXFLAGS -lgnustl_shared" \
		-DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX \
		-DCMAKE_LINKER=`which ${TERMUX_HOST_PLATFORM}-ld` \
		-DCMAKE_RANLIB=`which ${TERMUX_HOST_PLATFORM}-ranlib` \
		-DCMAKE_SYSTEM_NAME=Linux \
		-DLLVM_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/llvm-tblgen \
		-DLLVM_DEFAULT_TARGET_TRIPLE=$LLVM_DEFAULT_TARGET_TRIPLE \
		-DLLVM_TARGET_ARCH=$LLVM_TARGET_ARCH \
		-DLLVM_TARGETS_TO_BUILD=$LLVM_TARGET_ARCH \
		-DLLVM_ENABLE_PIC=ON \
                -DLLVM_INCLUDE_TESTS=Off \
		-DCLANG_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/clang-tblgen \
		-DC_INCLUDE_DIRS=$TERMUX_PREFIX/include \
                -DBUILD_SHARED_LIBS=On \
		$TERMUX_PKG_SRCDIR
}

termux_step_post_make_install () {
        (cd $TERMUX_PREFIX/bin && rm -f clang clang++ && ln -s clang-${_PKG_MAJOR_VERSION} clang && ln -s clang-${_PKG_MAJOR_VERSION} clang++)
}

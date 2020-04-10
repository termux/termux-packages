TERMUX_PKG_HOMEPAGE=https://clang.llvm.org/
TERMUX_PKG_DESCRIPTION="Modular compiler and toolchain technologies library"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_VERSION=10.0.0
TERMUX_PKG_SHA256=(df83a44b3a9a71029049ec101fb0077ecbbdf5fe41e395215025779099a98fdf
		   885b062b00e903df72631c5f98b9579ed1ed2790f74e5646b4234fa084eacb21
		   b9a0d7c576eeef05bc06d6e954938a01c5396cee1d1e985891e0b1cf16e3d708
		   3b9ff29a45d0509a1e9667a0feb43538ef402ea8cfc7df3758a01f20df08adfa)
TERMUX_PKG_SRCURL=(https://github.com/llvm/llvm-project/releases/download/llvmorg-$TERMUX_PKG_VERSION/llvm-$TERMUX_PKG_VERSION.src.tar.xz
                   https://github.com/llvm/llvm-project/releases/download/llvmorg-$TERMUX_PKG_VERSION/clang-$TERMUX_PKG_VERSION.src.tar.xz
                   https://github.com/llvm/llvm-project/releases/download/llvmorg-$TERMUX_PKG_VERSION/lld-$TERMUX_PKG_VERSION.src.tar.xz
                   https://github.com/llvm/llvm-project/releases/download/llvmorg-$TERMUX_PKG_VERSION/openmp-$TERMUX_PKG_VERSION.src.tar.xz)
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_RM_AFTER_INSTALL="
bin/clang-import-test
bin/clang-offload-wrapper
lib/libgomp.a
lib/libiomp5.a
"
TERMUX_PKG_DEPENDS="binutils, libc++, ncurses, ndk-sysroot, libffi, zlib"
# Replace gcc since gcc is deprecated by google on android and is not maintained upstream.
# Conflict with clang versions earlier than 3.9.1-3 since they bundled llvm.
TERMUX_PKG_CONFLICTS="gcc, clang (<< 3.9.1-3)"
TERMUX_PKG_BREAKS="libclang, libclang-dev, libllvm-dev"
TERMUX_PKG_REPLACES="gcc, libclang, libclang-dev, libllvm-dev"
# See http://llvm.org/docs/CMake.html:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DPYTHON_EXECUTABLE=$(which python3)
-DLLVM_ENABLE_PIC=ON
-DLLVM_ENABLE_LIBEDIT=OFF
-DLLVM_INCLUDE_TESTS=OFF
-DCLANG_DEFAULT_CXX_STDLIB=libc++
-DCLANG_INCLUDE_TESTS=OFF
-DCLANG_TOOL_C_INDEX_TEST_BUILD=OFF
-DDEFAULT_SYSROOT=$(dirname $TERMUX_PREFIX)
-DLLVM_LINK_LLVM_DYLIB=ON
-DLLVM_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/llvm-tblgen
-DCLANG_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/clang-tblgen
-DLIBOMP_ENABLE_SHARED=FALSE
-DOPENMP_ENABLE_LIBOMPTARGET=OFF
-DLLVM_BINUTILS_INCDIR=$TERMUX_PREFIX/include
-DLLVM_ENABLE_SPHINX=ON
-DSPHINX_OUTPUT_MAN=ON
-DLLVM_TARGETS_TO_BUILD=all
-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR;RISCV
-DPERL_EXECUTABLE=$(which perl)
-DLLVM_ENABLE_FFI=ON
"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_HAS_DEBUG=false
# Debug build succeeds but make install with:
# cp: cannot stat '../src/projects/openmp/runtime/exports/common.min.50.ompt.optional/include/omp.h': No such file or directory
# common.min.50.ompt.optional should be common.deb.50.ompt.optional when doing debug build

termux_step_post_extract_package() {
	if [ "$TERMUX_PKG_QUICK_REBUILD" = "false" ]; then
		mv clang-${TERMUX_PKG_VERSION}.src tools/clang
		mv lld-${TERMUX_PKG_VERSION}.src tools/lld
		mv openmp-${TERMUX_PKG_VERSION}.src projects/openmp
	fi
}

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	cmake -G Ninja $TERMUX_PKG_SRCDIR
	ninja -j $TERMUX_MAKE_PROCESSES clang-tblgen llvm-tblgen
}

termux_step_pre_configure() {
	if [ "$TERMUX_PKG_QUICK_REBUILD" = "false" ]; then
		mkdir projects/openmp/runtime/src/android
		cp $TERMUX_PKG_BUILDER_DIR/nl_types.h projects/openmp/runtime/src/android
		cp $TERMUX_PKG_BUILDER_DIR/nltypes_stubs.cpp projects/openmp/runtime/src/android
	fi

	export LLVM_DEFAULT_TARGET_TRIPLE=$TERMUX_HOST_PLATFORM
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
	# see CMakeLists.txt and tools/clang/CMakeLists.txt
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_TARGET_ARCH=$LLVM_TARGET_ARCH"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_HOST_TRIPLE=$LLVM_DEFAULT_TARGET_TRIPLE"
}

termux_step_post_make_install() {
	if [ $TERMUX_ARCH = "arm" ]; then
		cp $TERMUX_PKG_SRCDIR/projects/openmp/runtime/exports/common.min/include/omp.h $TERMUX_PREFIX/include
	else
		cp $TERMUX_PKG_SRCDIR/projects/openmp/runtime/exports/common.min.ompt.optional/include/omp.h $TERMUX_PREFIX/include
	fi

	if [ "$TERMUX_CMAKE_BUILD" = Ninja ]; then
		ninja docs-llvm-man
	else
		make docs-llvm-man
	fi

	cp docs/man/* $TERMUX_PREFIX/share/man/man1
	cd $TERMUX_PREFIX/bin

	for tool in clang clang++ cc c++ cpp gcc g++ ${TERMUX_HOST_PLATFORM}-{clang,clang++,gcc,g++,cpp}; do
		ln -f -s clang-${TERMUX_PKG_VERSION:0:2} $tool
	done
}

termux_step_post_massage() {
	# Not added to the package but kept around on the host for other packages like rust,
	# which relies on LLVM, to use for configuration.
	sed $TERMUX_PKG_BUILDER_DIR/llvm-config.in \
		-e "s|@TERMUX_PKG_VERSION@|$TERMUX_PKG_VERSION|g" \
		-e "s|@TERMUX_PKG_SRCDIR@|$TERMUX_PKG_SRCDIR|g" \
		-e "s|@LLVM_DEFAULT_TARGET_TRIPLE@|$LLVM_DEFAULT_TARGET_TRIPLE|g" \
		-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" > $TERMUX_PREFIX/bin/llvm-config
	chmod 755 $TERMUX_PREFIX/bin/llvm-config

	# These host binaries don't seem to be used anywhere, remove later if so.
	#cp $TERMUX_PKG_HOSTBUILD_DIR/bin/llvm-tblgen $TERMUX_PREFIX/bin
	#cp $TERMUX_PKG_HOSTBUILD_DIR/bin/clang-tblgen $TERMUX_PREFIX/bin
}

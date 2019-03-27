TERMUX_PKG_HOMEPAGE=https://clang.llvm.org/
TERMUX_PKG_DESCRIPTION="Modular compiler and toolchain technologies library"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_VERSION=8.0.0
TERMUX_PKG_SHA256=(8872be1b12c61450cacc82b3d153eab02be2546ef34fa3580ed14137bb26224c
                   084c115aab0084e63b23eee8c233abb6739c399e29966eaeccfc6e088e0b736b
		   9caec8ec922e32ffa130f0fb08e4c5a242d7e68ce757631e425e9eba2e1a6e37
		   f7b1705d2f16c4fc23d6531f67d2dd6fb78a077dd346b02fed64f4b8df65c9d5)
TERMUX_PKG_SRCURL=(https://releases.llvm.org/${TERMUX_PKG_VERSION}/llvm-${TERMUX_PKG_VERSION}.src.tar.xz
		   https://releases.llvm.org/${TERMUX_PKG_VERSION}/cfe-${TERMUX_PKG_VERSION}.src.tar.xz
		   https://llvm.org/releases/${TERMUX_PKG_VERSION}/lld-${TERMUX_PKG_VERSION}.src.tar.xz
		   https://releases.llvm.org/${TERMUX_PKG_VERSION}/openmp-${TERMUX_PKG_VERSION}.src.tar.xz)
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_RM_AFTER_INSTALL="
bin/clang-check
bin/clang-import-test
bin/clang-offload-bundler
bin/git-clang-format
bin/macho-dump
lib/libgomp.a
lib/libiomp5.a
"
TERMUX_PKG_DEPENDS="binutils, ncurses, ndk-sysroot, libffi"
# Replace gcc since gcc is deprecated by google on android and is not maintained upstream.
# Conflict with clang versions earlier than 3.9.1-3 since they bundled llvm.
TERMUX_PKG_CONFLICTS="gcc, clang (<< 3.9.1-3)"
TERMUX_PKG_REPLACES=gcc
# See http://llvm.org/docs/CMake.html:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DPYTHON_EXECUTABLE=$(which python3)
-DLLVM_ENABLE_PIC=ON
-DLLVM_ENABLE_LIBEDIT=OFF
-DLLVM_BUILD_TESTS=OFF
-DLLVM_INCLUDE_TESTS=OFF
-DCLANG_DEFAULT_CXX_STDLIB=libc++
-DCLANG_INCLUDE_TESTS=OFF
-DCLANG_TOOL_C_INDEX_TEST_BUILD=OFF
-DC_INCLUDE_DIRS=$TERMUX_PREFIX/include
-DLLVM_LINK_LLVM_DYLIB=ON
-DLLVM_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/llvm-tblgen
-DCLANG_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/clang-tblgen
-DLIBOMP_ENABLE_SHARED=FALSE
-DOPENMP_ENABLE_LIBOMPTARGET=OFF
-DLLVM_BINUTILS_INCDIR=$TERMUX_PREFIX/include
-DLLVM_ENABLE_SPHINX=ON
-DSPHINX_OUTPUT_MAN=ON
-DLLVM_TARGETS_TO_BUILD=all
-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=RISCV
-DPERL_EXECUTABLE=$(which perl)
-DLLVM_ENABLE_FFI=ON
"
TERMUX_PKG_FORCE_CMAKE=yes
TERMUX_PKG_KEEP_STATIC_LIBRARIES=true
TERMUX_PKG_HAS_DEBUG=no

termux_step_post_extract_package() {
	mv cfe-${TERMUX_PKG_VERSION}.src tools/clang
	mv lld-${TERMUX_PKG_VERSION}.src tools/lld
	mv openmp-${TERMUX_PKG_VERSION}.src projects/openmp
}

termux_step_host_build() {
	termux_setup_cmake
	cmake -G "Unix Makefiles" $TERMUX_PKG_SRCDIR \
		-DLLVM_BUILD_TESTS=OFF \
		-DLLVM_INCLUDE_TESTS=OFF
	make -j $TERMUX_MAKE_PROCESSES clang-tblgen llvm-tblgen
}

termux_step_pre_configure() {
	mkdir projects/openmp/runtime/src/android
	cp $TERMUX_PKG_BUILDER_DIR/nl_types.h projects/openmp/runtime/src/android
	cp $TERMUX_PKG_BUILDER_DIR/nltypes_stubs.cpp projects/openmp/runtime/src/android

	cd $TERMUX_PKG_BUILDDIR
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
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_DEFAULT_TARGET_TRIPLE=$LLVM_DEFAULT_TARGET_TRIPLE"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_TARGET_ARCH=$LLVM_TARGET_ARCH -DLLVM_TARGETS_TO_BUILD=all"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_HOST_TRIPLE=$LLVM_DEFAULT_TARGET_TRIPLE"
}
termux_step_post_make_install() {
	if [ $TERMUX_ARCH = "arm" ]; then
		cp ../src/projects/openmp/runtime/exports/common.min.50/include/omp.h $TERMUX_PREFIX/include
	else
		cp ../src/projects/openmp/runtime/exports/common.min.50.ompt.optional/include/omp.h $TERMUX_PREFIX/include
	fi

	if [ $TERMUX_CMAKE_BUILD = Ninja ]; then
		ninja docs-llvm-man
	else
		make docs-llvm-man
	fi

	cp docs/man/* $TERMUX_PREFIX/share/man/man1
	cd $TERMUX_PREFIX/bin

	for tool in clang clang++ cc c++ cpp gcc g++ ${TERMUX_HOST_PLATFORM}-{clang,clang++,gcc,g++,cpp}; do
		ln -f -s clang-${TERMUX_PKG_VERSION:0:1} $tool
	done
}

termux_step_post_massage() {
	sed $TERMUX_PKG_BUILDER_DIR/llvm-config.in \
		-e "s|@TERMUX_PKG_VERSION@|$TERMUX_PKG_VERSION|g" \
		-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		-e "s|@TERMUX_PKG_SRCDIR@|$TERMUX_PKG_SRCDIR|g" \
		-e "s|@LLVM_TARGET_ARCH@|$LLVM_TARGET_ARCH|g" \
		-e "s|@LLVM_DEFAULT_TARGET_TRIPLE@|$LLVM_DEFAULT_TARGET_TRIPLE|g" \
		-e "s|@TERMUX_ARCH@|$TERMUX_ARCH|g" > $TERMUX_PREFIX/bin/llvm-config
	chmod 755 $TERMUX_PREFIX/bin/llvm-config
	cp $TERMUX_PKG_HOSTBUILD_DIR/bin/llvm-tblgen $TERMUX_PREFIX/bin
	cp $TERMUX_PKG_HOSTBUILD_DIR/bin/clang-tblgen $TERMUX_PREFIX/bin
}

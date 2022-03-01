TERMUX_PKG_HOMEPAGE=https://clang.llvm.org/
TERMUX_PKG_DESCRIPTION="Modular compiler and toolchain technologies library"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_MAINTAINER="@buttaface"
TERMUX_PKG_VERSION=13.0.1
TERMUX_PKG_SHA256=326335a830f2e32d06d0a36393b5455d17dc73e0bd1211065227ee014f92cbf8
TERMUX_PKG_SRCURL=https://github.com/llvm/llvm-project/releases/download/llvmorg-$TERMUX_PKG_VERSION/llvm-project-$TERMUX_PKG_VERSION.src.tar.xz
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_RM_AFTER_INSTALL="
bin/ld64.lld.darwin*
lib/libgomp.a
lib/libiomp5.a
"
TERMUX_PKG_DEPENDS="libc++, ncurses, libffi, zlib, libxml2"
# Replace gcc since gcc is deprecated by google on android and is not maintained upstream.
# Conflict with clang versions earlier than 3.9.1-3 since they bundled llvm.
TERMUX_PKG_CONFLICTS="gcc, clang (<< 3.9.1-3)"
TERMUX_PKG_BREAKS="libclang, libclang-dev, libllvm-dev"
TERMUX_PKG_REPLACES="gcc, libclang, libclang-dev, libllvm-dev"
TERMUX_PKG_GROUPS="base-devel"
# See http://llvm.org/docs/CMake.html:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DPYTHON_EXECUTABLE=$(command -v python3)
-DLLVM_ENABLE_PIC=ON
-DLLVM_ENABLE_PROJECTS=clang;clang-tools-extra;compiler-rt;lld;lldb;openmp;polly
-DLLVM_ENABLE_LIBEDIT=OFF
-DLLVM_INCLUDE_TESTS=OFF
-DCLANG_DEFAULT_CXX_STDLIB=libc++
-DCLANG_DEFAULT_LINKER=lld
-DCLANG_INCLUDE_TESTS=OFF
-DCLANG_TOOL_C_INDEX_TEST_BUILD=OFF
-DCOMPILER_RT_USE_BUILTINS_LIBRARY=ON
-DDEFAULT_SYSROOT=$(dirname $TERMUX_PREFIX)
-DLLVM_LINK_LLVM_DYLIB=ON
-DLLDB_ENABLE_PYTHON=OFF
-DLLDB_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/lldb-tblgen
-DLLVM_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/llvm-tblgen
-DCLANG_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/clang-tblgen
-DLIBOMP_ENABLE_SHARED=FALSE
-DOPENMP_ENABLE_LIBOMPTARGET=OFF
-DLLVM_ENABLE_SPHINX=ON
-DSPHINX_OUTPUT_MAN=ON
-DSPHINX_WARNINGS_AS_ERRORS=OFF
-DLLVM_TARGETS_TO_BUILD=all
-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR;RISCV
-DPERL_EXECUTABLE=$(command -v perl)
-DLLVM_ENABLE_FFI=ON
"

if [ $TERMUX_ARCH_BITS = 32 ]; then
	# Do not set _FILE_OFFSET_BITS=64
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_FORCE_SMALLFILE_FOR_ANDROID=on"
fi

TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_HAS_DEBUG=false
# Debug build succeeds but make install with:
# cp: cannot stat '../src/projects/openmp/runtime/exports/common.min.50.ompt.optional/include/omp.h': No such file or directory
# common.min.50.ompt.optional should be common.deb.50.ompt.optional when doing debug build

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	cmake -G Ninja -DLLVM_ENABLE_PROJECTS='clang;lldb' $TERMUX_PKG_SRCDIR/llvm
	ninja -j $TERMUX_MAKE_PROCESSES clang-tblgen lldb-tblgen llvm-tblgen
}

termux_step_pre_configure() {
	mkdir openmp/runtime/src/android
	cp $TERMUX_PKG_BUILDER_DIR/nl_types.h openmp/runtime/src/android
	cp $TERMUX_PKG_BUILDER_DIR/nltypes_stubs.cpp openmp/runtime/src/android

	# Add unknown vendor, otherwise it screws with the default LLVM triple
	# detection.
	export LLVM_DEFAULT_TARGET_TRIPLE=${CCTERMUX_HOST_PLATFORM/-/-unknown-}
	export LLVM_TARGET_ARCH
	if [ $TERMUX_ARCH = "arm" ]; then
		LLVM_TARGET_ARCH=ARM
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		LLVM_TARGET_ARCH=AArch64
	elif [ $TERMUX_ARCH = "i686" ] || [ $TERMUX_ARCH = "x86_64" ]; then
		LLVM_TARGET_ARCH=X86
	else
		termux_error_exit "Invalid arch: $TERMUX_ARCH"
	fi
	# see CMakeLists.txt and tools/clang/CMakeLists.txt
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_TARGET_ARCH=$LLVM_TARGET_ARCH"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_HOST_TRIPLE=$LLVM_DEFAULT_TARGET_TRIPLE"
	export TERMUX_SRCDIR_SAVE=$TERMUX_PKG_SRCDIR
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/llvm
}

termux_step_post_configure() {
	TERMUX_PKG_SRCDIR=$TERMUX_SRCDIR_SAVE
}

termux_step_post_make_install() {
	if [ "$TERMUX_CMAKE_BUILD" = Ninja ]; then
		ninja docs-llvm-man docs-clang-man
	else
		make docs-llvm-man docs-clang-man
	fi

	cp docs/man/* $TERMUX_PREFIX/share/man/man1
	cp tools/clang/docs/man/clang.1 $TERMUX_PREFIX/share/man/man1
	cd $TERMUX_PREFIX/bin

	for tool in clang clang++ cc c++ cpp gcc g++ ${TERMUX_HOST_PLATFORM}-{clang,clang++,gcc,g++,cpp}; do
		ln -f -s clang-${TERMUX_PKG_VERSION:0:2} $tool
	done

	if [ $TERMUX_ARCH == "arm" ]; then
		# For arm we replace symlinks with the same type of
		# wrapper as the ndk uses to choose correct target
		for tool in ${TERMUX_HOST_PLATFORM}-{clang,gcc}; do
			unlink $tool
			cat <<- EOF > $tool
			#!$TERMUX_PREFIX/bin/bash
			if [ "\$1" != "-cc1" ]; then
				\`dirname \$0\`/clang --target=armv7a-linux-androideabi$TERMUX_PKG_API_LEVEL "\$@"
			else
				# Target is already an argument.
				\`dirname \$0\`/clang "\$@"
			fi
			EOF
			chmod u+x $tool
		done
		for tool in ${TERMUX_HOST_PLATFORM}-{clang++,g++}; do
			unlink $tool
			cat <<- EOF > $tool
			#!$TERMUX_PREFIX/bin/bash
			if [ "\$1" != "-cc1" ]; then
				\`dirname \$0\`/clang++ --target=armv7a-linux-androideabi$TERMUX_PKG_API_LEVEL "\$@"
			else
				# Target is already an argument.
				\`dirname \$0\`/clang++ "\$@"
			fi
			EOF
			chmod u+x $tool
		done
	fi
}

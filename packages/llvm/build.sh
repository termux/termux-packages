TERMUX_PKG_HOMEPAGE=https://clang.llvm.org/
TERMUX_PKG_DESCRIPTION="Modular compiler and toolchain technologies library"
_PKG_MAJOR_VERSION=6.0
TERMUX_PKG_VERSION=${_PKG_MAJOR_VERSION}.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SHA256=1ff53c915b4e761ef400b803f07261ade637b0c269d99569f18040f3dcee4408
TERMUX_PKG_SRCURL=https://releases.llvm.org/${TERMUX_PKG_VERSION}/llvm-${TERMUX_PKG_VERSION}.src.tar.xz
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_RM_AFTER_INSTALL="
bin/clang-offload-bundler
bin/git-clang-format
bin/macho-dump
lib/libgomp.a
lib/libiomp5.a
"
TERMUX_PKG_DEPENDS="binutils, ncurses, ndk-sysroot, ndk-stl, libffi, libllvm"
# Replace gcc since gcc is deprecated by google on android and is not maintained upstream.
# Conflict with clang versions earlier than 3.9.1-3 since they bundled llvm.
TERMUX_PKG_CONFLICTS="gcc, clang (<< 3.9.1-3)"
TERMUX_PKG_REPLACES=gcc
# See http://llvm.org/docs/CMake.html:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DPYTHON_EXECUTABLE=`which python`
-DLLVM_ENABLE_PIC=ON
-DLLVM_ENABLE_LIBEDIT=ON
-DLLVM_INCLUDE_TESTS=OFF
-DLLVM_LINK_LLVM_DYLIB=ON
-DLLVM_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/llvm-tblgen
-DLLVM_BINUTILS_INCDIR=$TERMUX_PREFIX/include
-DLLVM_ENABLE_SPHINX=ON
-DSPHINX_OUTPUT_MAN=ON
-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly
-DPERL_EXECUTABLE=$(which perl)
-DLLVM_ENABLE_FFI=ON
-DLLVM_ENABLE_PEDANTIC=OFF
"
#-DCLANG_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/clang-tblgen
TERMUX_PKG_FORCE_CMAKE=yes
TERMUX_PKG_KEEP_STATIC_LIBRARIES=true

termux_step_host_build () {
	termux_setup_cmake
	# this is required since we need clang-tblgen for libclang.
	mkdir -p $TERMUX_TOPDIR/clang/cache
	local CLANG_SRC_TAR=cfe-${TERMUX_PKG_VERSION}.src.tar.xz
        termux_download \
                https://releases.llvm.org/${TERMUX_PKG_VERSION}/$CLANG_SRC_TAR \
                $TERMUX_TOPDIR/clang/cache/$CLANG_SRC_TAR \
                e07d6dd8d9ef196cfc8e8bb131cbd6a2ed0b1caf1715f9d05b0f0eeaddb6df32
	tar  xvf $TERMUX_TOPDIR/clang/cache/$CLANG_SRC_TAR -C $TERMUX_PKG_SRCDIR/tools
	mv $TERMUX_PKG_SRCDIR/tools/cfe-* $TERMUX_PKG_SRCDIR/tools/clang
		
	
	cmake -G "Unix Makefiles" $TERMUX_PKG_SRCDIR \
		-DLLVM_BUILD_TESTS=OFF \
		-DLLVM_INCLUDE_TESTS=OFF
	make -j $TERMUX_MAKE_PROCESSES clang-tblgen llvm-tblgen
}

termux_step_pre_configure () {
rm $TERMUX_PKG_SRCDIR/tools/clang -rf
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
	make docs-llvm-man
	cp docs/man/* $TERMUX_PREFIX/share/man/man1
}
termux_step_post_massage () {
	sed $TERMUX_PKG_BUILDER_DIR/llvm-config.in \
		-e "s|@TERMUX_PKG_VERSION@|$TERMUX_PKG_VERSION|g" \
		-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		-e "s|@TERMUX_PKG_SRCDIR@|$TERMUX_PKG_SRCDIR|g" \
		-e "s|@LLVM_TARGET_ARCH@|$LLVM_TARGET_ARCH|g" \
		-e "s|@LLVM_DEFAULT_TARGET_TRIPLE@|$LLVM_DEFAULT_TARGET_TRIPLE|g" \
		-e "s|@TERMUX_ARCH@|$TERMUX_ARCH|g" > $TERMUX_PREFIX/bin/llvm-config
	chmod 755 $TERMUX_PREFIX/bin/llvm-config
	cp $TERMUX_TOPDIR/llvm/host-build/bin/* $TERMUX_PREFIX/bin
}

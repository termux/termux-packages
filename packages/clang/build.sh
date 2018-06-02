TERMUX_PKG_HOMEPAGE=https://clang.llvm.org/
TERMUX_PKG_DESCRIPTION="Modular compiler and toolchain technologies library"
_PKG_MAJOR_VERSION=6.0
TERMUX_PKG_VERSION=${_PKG_MAJOR_VERSION}.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SHA256=e07d6dd8d9ef196cfc8e8bb131cbd6a2ed0b1caf1715f9d05b0f0eeaddb6df32
TERMUX_PKG_SRCURL=https://releases.llvm.org/${TERMUX_PKG_VERSION}/cfe-${TERMUX_PKG_VERSION}.src.tar.xz
TERMUX_PKG_NINJA=yes
TERMUX_PKG_RM_AFTER_INSTALL="
bin/clang-offload-bundler
bin/git-clang-format
bin/macho-dump
"
TERMUX_PKG_DEPENDS="libllvm, libclang"
# Replace gcc since gcc is deprecated by google on android and is not maintained upstream.
# Conflict with clang versions earlier than 3.9.1-3 since they bundled llvm.
TERMUX_PKG_CONFLICTS="gcc, clang (<< 3.9.1-3), libllvm-dev, libclang-dev (<< 6.0.0.2)"
TERMUX_PKG_REPLACES=gcc
TERMUX_PKG_NO_DEVELSPLIT="yes"
# See http://llvm.org/docs/CMake.html:
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="
lib/cmake
"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLLVM_ENABLE_PIC=ON
-DENABLE_SHARED=ON
-DLLVM_INCLUDE_TESTS=OFF
-DCLANG_DEFAULT_CXX_STDLIB=libc++
-DCLANG_INCLUDE_TESTS=OFF
-DCLANG_TOOL_C_INDEX_TEST_BUILD=OFF
-DC_INCLUDE_DIRS=$TERMUX_PREFIX/include
-DLLVM_LINK_LLVM_DYLIB=ON
-DLLVM_BINUTILS_INCDIR=$TERMUX_PREFIX/include
-DCLANG_TABLEGEN=$TERMUX_TOPDIR/llvm/host-build/bin/clang-tblgen
-DLLVM_TABLEGEN=$TERMUX_TOPDIR/llvm/host-build/bin/llvm-tblgen
-DLLVM_ENABLE_PEDANTIC=OFF
-DLLVM_CONFIG=$TERMUX_PREFIX/bin/llvm-config
-DCLANG_INCLUDE_DOCS=ON
-DSPHINX_WARNINGS_AS_ERRORS=OFF
"
TERMUX_PKG_FORCE_CMAKE=yes
TERMUX_PKG_KEEP_STATIC_LIBRARIES=true

termux_step_pre_configure () {
	LDFLAGS+=" -lLLVM"
	if [ $TERMUX_ARCH = "arm" ]; then
		CFLAGS+=" -fintegrated-as"
		CXXFLAGS+=" -fintegrated-as"
	fi
}
termux_step_post_make_install () {
	cd $TERMUX_PREFIX/bin

	for tool in clang clang++ cc c++ cpp gcc g++ ${TERMUX_HOST_PLATFORM}-{clang,clang++,gcc,g++,cpp}; do
		ln -f -s clang-${_PKG_MAJOR_VERSION} $tool
	done
}
termux_step_post_massage() {
	# this should be needed if you have to recompile clang?
	cp -f $TERMUX_TOPDIR/llvm/host-build/bin/* $TERMUX_PREFIX/bin
}

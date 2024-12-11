TERMUX_PKG_HOMEPAGE=https://flang.llvm.org/
TERMUX_PKG_DESCRIPTION="LLVM's Fortran frontend"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="flang/LICENSE.TXT"
TERMUX_PKG_MAINTAINER="@termux"
LLVM_MAJOR_VERSION=19
TERMUX_PKG_VERSION=${LLVM_MAJOR_VERSION}.1.5
TERMUX_PKG_SRCURL=https://github.com/llvm/llvm-project/releases/download/llvmorg-$TERMUX_PKG_VERSION/llvm-project-$TERMUX_PKG_VERSION.src.tar.xz
TERMUX_PKG_SHA256=bd8445f554aae33d50d3212a15e993a667c0ad1b694ac1977f3463db3338e542
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_HOSTBUILD=true
# `flang-new` should be rebuilt when libllvm bumps version.
# See https://github.com/termux/termux-packages/issues/19362
DEP_QUALIFIER=$TERMUX_PKG_VERSION-$TERMUX_PKG_REVISION
TERMUX_PKG_DEPENDS="libandroid-complex-math-static, libc++, libllvm (= $DEP_QUALIFIER), clang (= $DEP_QUALIFIER), lld (= $DEP_QUALIFIER), mlir (= $DEP_QUALIFIER)"
TERMUX_PKG_BUILD_DEPENDS="libllvm-static"

# Upstream doesn't support 32-bit arches well. See https://github.com/llvm/llvm-project/issues/57621.
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

# See http://llvm.org/docs/CMake.html:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_BUILD_TYPE=MinSizeRel
-DLLVM_ENABLE_PIC=ON
-DDEFAULT_SYSROOT=$(dirname $TERMUX_PREFIX)
-DLLVM_LINK_LLVM_DYLIB=ON
-DLLVM_TARGETS_TO_BUILD=all
-DLLVM_ENABLE_FFI=ON
-DFLANG_DEFAULT_LINKER=lld
-DMLIR_INSTALL_AGGREGATE_OBJECTS=OFF
-DFLANG_ENABLE_WERROR=On
-DFLANG_INCLUDE_TESTS=OFF
-DLLVM_ENABLE_ASSERTIONS=On
-DLLVM_LIT_ARGS=-v
-DLLVM_DIR=$TERMUX_PREFIX/lib/cmake/llvm
-DCLANG_DIR=$TERMUX_PREFIX/lib/cmake/clang
-DMLIR_DIR=$TERMUX_PREFIX/lib/cmake/mlir
-DMLIR_TABLEGEN_EXE=$TERMUX_PKG_HOSTBUILD_DIR/bin/mlir-tblgen
-DLLVM_NATIVE_TOOL_DIR=$TERMUX_PKG_HOSTBUILD_DIR/bin
-DCROSS_TOOLCHAIN_FLAGS_LLVM_NATIVE=-DLLVM_NATIVE_TOOL_DIR=$TERMUX_PKG_HOSTBUILD_DIR/bin
"

if [ $TERMUX_ARCH_BITS = 32 ]; then
	# Do not set _FILE_OFFSET_BITS=64
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_FORCE_SMALLFILE_FOR_ANDROID=on"
fi

TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_HAS_DEBUG=false
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	cmake -G Ninja "-DCMAKE_BUILD_TYPE=Release" \
					"-DLLVM_ENABLE_PROJECTS=clang;mlir" \
					$TERMUX_PKG_SRCDIR/llvm
	ninja -j $TERMUX_PKG_MAKE_PROCESSES clang-tblgen mlir-tblgen
}

termux_step_pre_configure() {
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/bin:$PATH"
	# Add unknown vendor, otherwise it screws with the default LLVM triple detection.
	export LLVM_DEFAULT_TARGET_TRIPLE=${CCTERMUX_HOST_PLATFORM/-/-unknown-}
	# see CMakeLists.txt and tools/clang/CMakeLists.txt
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_HOST_TRIPLE=$LLVM_DEFAULT_TARGET_TRIPLE"
	TERMUX_SRCDIR_SAVE=$TERMUX_PKG_SRCDIR
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/flang
	# Avoid the possible OOM
	TERMUX_PKG_MAKE_PROCESSES=1
}

termux_step_post_configure() {
	TERMUX_PKG_SRCDIR=$TERMUX_SRCDIR_SAVE
	unset TERMUX_SRCDIR_SAVE
}

termux_step_post_make_install() {
	# Copy module source files
	mkdir -p $TERMUX_PREFIX/opt/flang/{include,module}
	cp -f $TERMUX_PKG_SRCDIR/flang/module/* $TERMUX_PREFIX/opt/flang/module/
	ln -sf $TERMUX_PREFIX/include/flang $TERMUX_PREFIX/opt/flang/include/
}

termux_step_create_debscripts() {
	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		"$TERMUX_PKG_BUILDER_DIR/postinst.sh.in" > ./postinst
	chmod +x ./postinst

	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		"$TERMUX_PKG_BUILDER_DIR/prerm.sh.in" > ./prerm
	chmod +x ./prerm
}

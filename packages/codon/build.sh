TERMUX_PKG_HOMEPAGE=https://github.com/exaloop/codon
TERMUX_PKG_DESCRIPTION="A high-performance, zero-overhead, extensible Python compiler using LLVM"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
_LLVM_COMMIT=05ba68c2286e5b1972fb593f316987a07d81ebe1
TERMUX_PKG_VERSION="0.19.0"
TERMUX_PKG_SRCURL=(
	https://github.com/exaloop/codon/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
	https://github.com/exaloop/codon/releases/download/v$TERMUX_PKG_VERSION/codon-linux-x86_64.tar.gz
	https://github.com/exaloop/llvm-project/archive/${_LLVM_COMMIT}.zip
)
TERMUX_PKG_SHA256=(
	47c060b7ffacca4342970547c6e3befa0d2dcfc822449e7ffcc0daaec9e83a2f
	428488aa86119b70b485da1707bec00fa664690c84392e708b2e97b662f2652d
	3828457c3072419a5ee16c9c790cc021704931b7382ca435f8cff78cccb4f952
)
TERMUX_PKG_DEPENDS="libc++, libxml2, zlib, zstd"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true

# Args for the bundled LLVM
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DANDROID_PLATFORM_LEVEL=$TERMUX_PKG_API_LEVEL
-DPYTHON_EXECUTABLE=$(command -v python3)
-DLLVM_ENABLE_PIC=ON
-DLLVM_ENABLE_LIBEDIT=OFF
-DDEFAULT_SYSROOT=$(dirname $TERMUX_PREFIX)
-DLLVM_LINK_LLVM_DYLIB=on
-DLLVM_NATIVE_TOOL_DIR=$TERMUX_PKG_HOSTBUILD_DIR/llvm-build/bin
-DCROSS_TOOLCHAIN_FLAGS_LLVM_NATIVE=-DLLVM_NATIVE_TOOL_DIR=$TERMUX_PKG_HOSTBUILD_DIR/llvm-build/bin
-DLIBOMP_ENABLE_SHARED=ON
-DLLVM_ENABLE_SPHINX=ON
-DSPHINX_OUTPUT_MAN=ON
-DSPHINX_WARNINGS_AS_ERRORS=OFF
-DPERL_EXECUTABLE=$(command -v perl)
-DLLVM_INSTALL_UTILS=OFF
-DLLVM_INCLUDE_TESTS=OFF
-DLLVM_ENABLE_TERMINFO=OFF
-DLLVM_ENABLE_FFI=ON
-DLLVM_ENABLE_RTTI=ON
-DLLVM_ENABLE_ZLIB=OFF
-DLLVM_ENABLE_ZSTD=OFF
-DLLVM_TARGETS_TO_BUILD=all
-DLLVM_ENABLE_PROJECTS=clang;openmp
"
TERMUX_PKG_FORCE_CMAKE=true

# codon ships its own libomp.so
TERMUX_PKG_NO_OPENMP_CHECK=true

# On ARM and i686, codon crashes:
# JIT session error: Unsupported target machine architecture in ELF object codon-jitted-objectbuffer
# Failure value returned from cantFail wrapped call
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_post_get_source() {
	# Check llvm commit
	local _llvm_commit="$(strings codon-deploy/bin/codon | grep 'llvm-project' | cut -d' ' -f5 | cut -d')' -f1)"
	if [ "$_LLVM_COMMIT" != "$_llvm_commit" ]; then
		termux_error_exit "LLVM commit mismatch: current $_LLVM_COMMIT, expected $_llvm_commit."
	fi
	mv llvm-project-"$_llvm_commit" llvm-project
}

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	# Compile llvm host tools
	mkdir -p llvm-build
	cd llvm-build
	cmake -G Ninja \
		-DCMAKE_BUILD_TYPE=Release \
		-DLLVM_ENABLE_PROJECTS=clang \
		"$TERMUX_PKG_SRCDIR"/llvm-project/llvm
	ninja -j $TERMUX_PKG_MAKE_PROCESSES llvm-tblgen llvm-min-tblgen clang-tblgen
	cd -

	# Compile peg2cpp
	mkdir -p peg2cpp-build
	cd peg2cpp-build
	cp -f "$TERMUX_PKG_SRCDIR"/codon/util/peg2cpp.cpp ./peg2cpp.cpp
	cp -f "$TERMUX_PKG_BUILDER_DIR"/host-peg2cpp-CMakeLists.txt ./CMakeLists.txt
	cmake -G Ninja .
	ninja -j $TERMUX_PKG_MAKE_PROCESSES peg2cpp
}

__codon_build_llvm() {
	export _CODON_LLVM_INSTALL_DIR="$TERMUX_PKG_BUILDDIR"/llvm-install
	if [ -f "$_CODON_LLVM_INSTALL_DIR"/.codon-llvm-built ]; then
		return
	fi

	termux_setup_cmake
	termux_setup_ninja

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
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_TARGET_ARCH=$LLVM_TARGET_ARCH"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_HOST_TRIPLE=$LLVM_DEFAULT_TARGET_TRIPLE"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_INSTALL_PREFIX=$_CODON_LLVM_INSTALL_DIR"

	# Backup dirs
	local __old_srcdir="$TERMUX_PKG_SRCDIR"
	local __old_builddir="$TERMUX_PKG_BUILDDIR"
	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR"/llvm-project/llvm
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_BUILDDIR"/llvm-build

	# Configure
	mkdir -p "$TERMUX_PKG_BUILDDIR"
	cd "$TERMUX_PKG_BUILDDIR"
	termux_step_configure_cmake

	# Cross-compile & install LLVM
	cd "$TERMUX_PKG_BUILDDIR"
	ninja -j $TERMUX_PKG_MAKE_PROCESSES install

	# Recover dirs
	TERMUX_PKG_SRCDIR="$__old_srcdir"
	TERMUX_PKG_BUILDDIR="$__old_builddir"

	# Mark as built
	mkdir -p "$_CODON_LLVM_INSTALL_DIR"
	touch -f "$_CODON_LLVM_INSTALL_DIR"/.codon-llvm-built
}

termux_step_configure() {
	__codon_build_llvm

	termux_setup_cmake
	termux_setup_ninja
	termux_setup_flang

	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/peg2cpp-build:$PATH"
	local _RPATH_FLAG="-Wl,-rpath=$TERMUX_PREFIX/lib"
	local _RPATH_FLAG_ADD="-Wl,-rpath='\$ORIGIN' -Wl,-rpath='\$ORIGIN/../lib/codon' -Wl,-rpath=$TERMUX_PREFIX/lib"
	LDFLAGS="${LDFLAGS/$_RPATH_FLAG/$_RPATH_FLAG_ADD}"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DLLVM_DIR=$_CODON_LLVM_INSTALL_DIR/lib/cmake/llvm"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX/opt/codon"
	# TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_ASM_FLAGS=--target=$CCTERMUX_HOST_PLATFORM"

	if [ "$TERMUX_ARCH" = "x86_64" ] || [ "$TERMUX_ARCH" = "i686" ]; then
		export OPENBLAS_CROSS_TARGET="TARGET CORE2"
	fi

	cd "$TERMUX_PKG_BUILDDIR"
	termux_step_configure_cmake
}

termux_step_post_make_install() {
	# Create start script
	cat << EOF > $TERMUX_PREFIX/bin/codon
#!$TERMUX_PREFIX/bin/env sh

export PATH="$TERMUX_PREFIX/opt/codon/bin:\$PATH"
exec $TERMUX_PREFIX/opt/codon/bin/codon "\$@"

EOF
	chmod +x $TERMUX_PREFIX/bin/codon
}

termux_step_post_massage() {
	# Remove some unrelated includes and libraries
	rm -rf include lib
}

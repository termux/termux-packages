TERMUX_PKG_HOMEPAGE=https://llvmlite.pydata.org/
TERMUX_PKG_DESCRIPTION="A lightweight LLVM python binding for writing JIT compilers"
# LICENSES: BSD 2-Clause, Apache-2.0 with LLVM Exceptions
TERMUX_PKG_LICENSE="BSD 2-Clause, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE.thirdparty"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(
	"0.46.0"
	"20.1.8"
)
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=(
	"https://github.com/numba/llvmlite/archive/refs/tags/v${TERMUX_PKG_VERSION[0]}.tar.gz"
	"https://github.com/llvm/llvm-project/releases/download/llvmorg-${TERMUX_PKG_VERSION[1]}/llvm-project-${TERMUX_PKG_VERSION[1]}.src.tar.xz"
)
TERMUX_PKG_SHA256=(
	34733887fd325a7392eef69b15879d37b02694e1e6b01ba11ed67c3b251290c5
	6898f963c8e938981e6c4a302e83ec5beb4630147c7311183cf61069af16333d
)
TERMUX_PKG_DEPENDS="libc++, libffi, python, python-pip"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true

# See http://llvm.org/docs/CMake.html:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DANDROID_PLATFORM_LEVEL=$TERMUX_PKG_API_LEVEL
-DPYTHON_EXECUTABLE=$(command -v python3)
-DLLVM_ENABLE_PIC=ON
-DLLVM_INCLUDE_TESTS=OFF
-DDEFAULT_SYSROOT=$(dirname $TERMUX_PREFIX)
-DLLVM_NATIVE_TOOL_DIR=$TERMUX_PKG_HOSTBUILD_DIR/bin
-DCROSS_TOOLCHAIN_FLAGS_LLVM_NATIVE=-DLLVM_NATIVE_TOOL_DIR=$TERMUX_PKG_HOSTBUILD_DIR/bin
-DLIBOMP_ENABLE_SHARED=FALSE
-DLLVM_ENABLE_SPHINX=ON
-DSPHINX_OUTPUT_MAN=ON
-DSPHINX_WARNINGS_AS_ERRORS=OFF
-DLLVM_TARGETS_TO_BUILD=all
-DPERL_EXECUTABLE=$(command -v perl)
-DLLVM_ENABLE_ZSTD=OFF
-DLLVM_ENABLE_LIBEDIT=OFF
-DLLVM_ENABLE_LIBXML2=OFF
-DLLVM_ENABLE_RTTI=OFF
-DLLVM_ENABLE_TERMINFO=OFF
-DLLVM_INCLUDE_BENCHMARKS=OFF
-DLLVM_INCLUDE_DOCS=OFF
-DLLVM_INCLUDE_EXAMPLES=OFF
-DLLVM_INCLUDE_GO_TESTS=OFF
-DLLVM_INCLUDE_UTILS=ON
-DLLVM_INSTALL_UTILS=ON
-DLLVM_BUILD_LLVM_DYLIB=OFF
-DLLVM_LINK_LLVM_DYLIB=OFF
-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly
-DLLVM_ENABLE_FFI=ON
-DLLVM_ENABLE_Z3_SOLVER=OFF
-DLLVM_OPTIMIZED_TABLEGEN=ON
"

if [ $TERMUX_ARCH_BITS = 32 ]; then
	# Do not set _FILE_OFFSET_BITS=64
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_FORCE_SMALLFILE_FOR_ANDROID=on"
fi

termux_step_post_get_source() {
	mv llvm-project-"${TERMUX_PKG_VERSION[1]}".src llvm-project
}

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	cmake -G Ninja "-DCMAKE_BUILD_TYPE=Release" \
					"-DLLVM_ENABLE_PROJECTS=clang" \
					$TERMUX_PKG_SRCDIR/llvm-project/llvm
	ninja -j $TERMUX_PKG_MAKE_PROCESSES llvm-tblgen clang-tblgen
}

__llvmlite_build_llvm() {
	export _LLVMLITE_LLVM_INSTALL_DIR="$TERMUX_PKG_BUILDDIR"/llvm-install
	if [ -f "$_LLVMLITE_LLVM_INSTALL_DIR"/.llvmlite-llvm-built ]; then
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
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_INSTALL_PREFIX=$_LLVMLITE_LLVM_INSTALL_DIR"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_INSTALL_INCLUDEDIR=$_LLVMLITE_LLVM_INSTALL_DIR/include"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_INSTALL_LIBDIR=$_LLVMLITE_LLVM_INSTALL_DIR/lib"

	# Backup dirs and envs
	local __old_ldflags="$LDFLAGS"
	local __old_srcdir="$TERMUX_PKG_SRCDIR"
	local __old_builddir="$TERMUX_PKG_BUILDDIR"
	LDFLAGS="-Wl,--undefined-version $LDFLAGS"
	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR"/llvm-project/llvm
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_BUILDDIR"/llvm-build

	# Configure
	mkdir -p "$TERMUX_PKG_BUILDDIR"
	cd "$TERMUX_PKG_BUILDDIR"
	termux_step_configure_cmake

	# Cross-compile & install LLVM
	cd "$TERMUX_PKG_BUILDDIR"
	ninja -j $TERMUX_PKG_MAKE_PROCESSES install

	# Recover dirs and envs
	LDFLAGS="$__old_ldflags"
	TERMUX_PKG_SRCDIR="$__old_srcdir"
	TERMUX_PKG_BUILDDIR="$__old_builddir"

	# Mark as built
	mkdir -p "$_LLVMLITE_LLVM_INSTALL_DIR"
	touch -f "$_LLVMLITE_LLVM_INSTALL_DIR"/.llvmlite-llvm-built
}

__llvmlite_build_lib() {
	termux_setup_cmake
	termux_setup_ninja

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DLLVM_DIR=$_LLVMLITE_LLVM_INSTALL_DIR/lib/cmake/llvm"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_POLICY_VERSION_MINIMUM=3.5"

	# Backup dirs and envs
	local __old_srcdir="$TERMUX_PKG_SRCDIR"
	local __old_builddir="$TERMUX_PKG_BUILDDIR"
	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR"/ffi
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"/build

	# Configure
	mkdir -p "$TERMUX_PKG_BUILDDIR"
	cd "$TERMUX_PKG_BUILDDIR"
	termux_step_configure_cmake

	# Cross-compile llvmlite
	cd "$TERMUX_PKG_BUILDDIR"
	ninja -j $TERMUX_PKG_MAKE_PROCESSES

	# Recover dirs and envs
	TERMUX_PKG_SRCDIR="$__old_srcdir"
	TERMUX_PKG_BUILDDIR="$__old_builddir"
}

termux_step_configure() {
	:
}

termux_step_make() {
	__llvmlite_build_llvm

	__llvmlite_build_lib

	# Copy libs
	cp -f "$TERMUX_PKG_SRCDIR"/ffi/build/libllvmlite.so "$TERMUX_PKG_SRCDIR"/llvmlite/binding/
}

termux_step_make_install() {
	LDFLAGS+=" -Wl,--no-as-needed -lpython${TERMUX_PYTHON_VERSION}"

	export LLVMLITE_SKIP_BUILD_LIBRARY=1
	pip install . --prefix="$TERMUX_PREFIX" -vv --no-build-isolation --no-deps
}

termux_step_post_massage() {
	local dir="include"
	if [[ -d "${TERMUX_PKG_MASSAGEDIR}${TERMUX_PREFIX}/$dir" ]]; then
		termux_error_exit "$dir should not exist in $TERMUX_PKG_NAME!"
	fi
}

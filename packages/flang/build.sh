TERMUX_PKG_HOMEPAGE=https://flang.llvm.org/
TERMUX_PKG_DESCRIPTION="LLVM's Fortran frontend"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="flang/LICENSE.TXT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=21.1.8
TERMUX_PKG_SRCURL=(
	"https://github.com/llvm/llvm-project/releases/download/llvmorg-${TERMUX_PKG_VERSION}/llvm-project-${TERMUX_PKG_VERSION}.src.tar.xz"
	"https://github.com/llvm/llvm-project/releases/download/llvmorg-${TERMUX_PKG_VERSION}/LLVM-${TERMUX_PKG_VERSION}-Linux-X64.tar.xz"
)
TERMUX_PKG_SHA256=(
	4633a23617fa31a3ea51242586ea7fb1da7140e426bd62fc164261fe036aa142
	b3b7f2801d15d50736acea3c73982994d025b01c2f035b91ae3b49d1b575732b
)
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_HOSTBUILD=true
# `flang-new` should be rebuilt when libllvm bumps version.
# See https://github.com/termux/termux-packages/issues/19362
dep_qualifier="$TERMUX_PKG_VERSION-$TERMUX_PKG_REVISION"
TERMUX_PKG_DEPENDS="libandroid-complex-math-static, libc++, libllvm (= $dep_qualifier), clang (= $dep_qualifier), lld (= $dep_qualifier), mlir (= $dep_qualifier)"
TERMUX_PKG_BUILD_DEPENDS="libllvm-static"
unset dep_qualifier

# Upstream doesn't support 32-bit arches well. See https://github.com/llvm/llvm-project/issues/57621.
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true

# See http://llvm.org/docs/CMake.html:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_BUILD_TYPE=MinSizeRel
-DLLVM_ENABLE_PIC=ON
-DLLVM_LINK_LLVM_DYLIB=ON
-DLLVM_TARGETS_TO_BUILD=all
-DLLVM_ENABLE_FFI=ON
-DFLANG_DEFAULT_LINKER=lld
-DMLIR_INSTALL_AGGREGATE_OBJECTS=OFF
-DFLANG_INCLUDE_TESTS=OFF
-DLLVM_ENABLE_ASSERTIONS=ON
-DLLVM_LIT_ARGS=-v
-DLLVM_DIR=$TERMUX_PREFIX/lib/cmake/llvm
-DCLANG_DIR=$TERMUX_PREFIX/lib/cmake/clang
-DMLIR_DIR=$TERMUX_PREFIX/lib/cmake/mlir
-DMLIR_TABLEGEN_EXE=$TERMUX_PKG_HOSTBUILD_DIR/bin/mlir-tblgen
-DLLVM_NATIVE_TOOL_DIR=$TERMUX_PKG_HOSTBUILD_DIR/bin
-DCROSS_TOOLCHAIN_FLAGS_LLVM_NATIVE=-DLLVM_NATIVE_TOOL_DIR=$TERMUX_PKG_HOSTBUILD_DIR/bin
"
# -DDEFAULT_SYSROOT=$(dirname $TERMUX_PREFIX)

if (( TERMUX_ARCH_BITS == 32 )); then
	# Do not set _FILE_OFFSET_BITS=64
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_FORCE_SMALLFILE_FOR_ANDROID=on"
fi

TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_HAS_DEBUG=false
TERMUX_PKG_NO_STATICSPLIT=true

# shellcheck disable=SC2030,2031
termux_step_post_get_source() {
	# Version guard to keep flang in sync
	local llvm_version llvm_revision
	llvm_version="$(. "$TERMUX_SCRIPTDIR/packages/libllvm/build.sh"; echo "${TERMUX_PKG_VERSION}")"
	llvm_revision="$(TERMUX_PKG_REVISION=0; . "$TERMUX_SCRIPTDIR/packages/libllvm/build.sh"; echo "${TERMUX_PKG_REVISION}")"
	if [[ "${llvm_version}-${llvm_revision}" != "${TERMUX_PKG_VERSION}-${TERMUX_PKG_REVISION:-0}" ]]; then
		termux_error_exit "Version mismatch between libllvm and flang. flang=$TERMUX_PKG_VERSION-$TERMUX_PKG_REVISION, libllvm=$llvm_version-$llvm_revision"
	fi
}

# shellcheck disable=SC2031
termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	cmake -G Ninja "-DCMAKE_BUILD_TYPE=Release" \
					"-DLLVM_ENABLE_PROJECTS=clang;mlir" \
					"$TERMUX_PKG_SRCDIR/llvm"
	ninja -j "$TERMUX_PKG_MAKE_PROCESSES" clang-tblgen mlir-tblgen
}

# shellcheck disable=SC2031
termux_step_pre_configure() {
	local default_sysroot
	if [[ "$TERMUX__PREFIX" == "$TERMUX__ROOTFS" ]]; then
		default_sysroot=".."
	else
		default_sysroot="../.."
	fi
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DDEFAULT_SYSROOT=$default_sysroot"
}

# shellcheck disable=SC2030,2031
__flang_build_runtime() {
	if [[ -f "$TERMUX_PKG_BUILDDIR"/.flang-rt-built ]]; then
		return
	fi

	termux_setup_cmake
	termux_setup_ninja

	# Add target to flang
	mkdir -p "$TERMUX_PKG_TMPDIR/flang-bin"
	cat <<- EOF > "$TERMUX_PKG_TMPDIR/flang-bin/${TERMUX_HOST_PLATFORM}-flang-new"
	#!/usr/bin/env bash
	if [[ "\$1" != "-cpp" && "\$1" != "-fc1" ]]; then
		"$TERMUX_PKG_SRCDIR/LLVM-$TERMUX_PKG_VERSION-Linux-X64/bin/flang-new" --target="${TERMUX_HOST_PLATFORM}${TERMUX_PKG_API_LEVEL}" -D__ANDROID_API__="$TERMUX_PKG_API_LEVEL" "\$@"
	else
		# Target is already an argument.
		"$TERMUX_PKG_SRCDIR/LLVM-$TERMUX_PKG_VERSION-Linux-X64/bin/flang-new" "\$@"
	fi
	EOF
	chmod u+x "$TERMUX_PKG_TMPDIR/flang-bin/${TERMUX_HOST_PLATFORM}-flang-new"

	( # Use a subshell to not effect the values outside this function
	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR/runtimes"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_BUILDDIR"/flang-rt-build
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCLANG_VERSION_MAJOR=${TERMUX_PKG_VERSION%%.*}"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_ENABLE_RUNTIMES=flang-rt"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_Fortran_COMPILER=$TERMUX_PKG_TMPDIR/flang-bin/${TERMUX_HOST_PLATFORM}-flang-new"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_Fortran_COMPILER_WORKS=yes"

	# Configure
	mkdir -p "$TERMUX_PKG_BUILDDIR"
	cd "$TERMUX_PKG_BUILDDIR" && \
	termux_step_configure_cmake

	# Cross-compile Flang runtime
	ninja -j "$TERMUX_PKG_MAKE_PROCESSES"
	)

	# Mark as built
	mkdir -p "$TERMUX_PKG_BUILDDIR"
	touch -f "$TERMUX_PKG_BUILDDIR"/.flang-rt-built
}

# shellcheck disable=SC2031
termux_step_configure() {
	# Add unknown vendor, otherwise it screws with the default LLVM triple detection.
	export LLVM_DEFAULT_TARGET_TRIPLE="${CCTERMUX_HOST_PLATFORM/-/-unknown-}"

	# Compile flang-rt
	__flang_build_runtime

	termux_setup_cmake
	termux_setup_ninja

	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/bin:$PATH"
	# see CMakeLists.txt and tools/clang/CMakeLists.txt
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_HOST_TRIPLE=$LLVM_DEFAULT_TARGET_TRIPLE"

	local __old_srcdir="$TERMUX_PKG_SRCDIR"
	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR/flang"

	termux_step_configure_cmake
	TERMUX_PKG_SRCDIR="$__old_srcdir"

	# Avoid the possible OOM
	TERMUX_PKG_MAKE_PROCESSES=1
}

# shellcheck disable=SC2031
termux_step_post_make_install() {
	# Install flang-rt
	cp -f "$TERMUX_PKG_BUILDDIR"/flang-rt-build/flang-rt/lib/libflang_rt.runtime.a \
		"$TERMUX_PREFIX"/lib/libflang_rt.runtime.a

	# Copy module source files
	mkdir -p "$TERMUX_PREFIX/opt/flang"/{include,module}
	cp -f "$TERMUX_PKG_SRCDIR/flang/module"/* "$TERMUX_PREFIX/opt/flang/module/"
	ln -sf "$TERMUX_PREFIX/include/flang" "$TERMUX_PREFIX/opt/flang/include/"
}

termux_step_create_debscripts() {
	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		"$TERMUX_PKG_BUILDER_DIR/postinst.sh.in" > ./postinst
	chmod +x ./postinst

	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		"$TERMUX_PKG_BUILDER_DIR/prerm.sh.in" > ./prerm
	chmod +x ./prerm
}

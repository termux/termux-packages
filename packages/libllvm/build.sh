TERMUX_PKG_HOMEPAGE=https://clang.llvm.org/
TERMUX_PKG_DESCRIPTION="Modular compiler and toolchain technologies library"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_LICENSE_FILE="llvm/LICENSE.TXT"
TERMUX_PKG_MAINTAINER="@finagolfin"
# Keep flang version and revision in sync when updating (enforced by check in termux_step_pre_configure).
TERMUX_PKG_VERSION=21.1.8
TERMUX_PKG_SHA256=4633a23617fa31a3ea51242586ea7fb1da7140e426bd62fc164261fe036aa142
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_SRCURL=https://github.com/llvm/llvm-project/releases/download/llvmorg-${TERMUX_PKG_VERSION}/llvm-project-${TERMUX_PKG_VERSION}.src.tar.xz
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_RM_AFTER_INSTALL="
bin/ld64.lld.darwin*
lib/libgomp.a
lib/libiomp5.a
share/man/man1/lit.1
"
TERMUX_PKG_DEPENDS="libc++, libffi, libxml2, ncurses, zlib, zstd"
# Replace gcc since gcc is deprecated by google on android and is not maintained upstream.
# Conflict with clang versions earlier than 3.9.1-3 since they bundled llvm.
TERMUX_PKG_CONFLICTS="gcc, clang (<< 3.9.1-3)"
TERMUX_PKG_BREAKS="libclang, libclang-dev, libllvm-dev"
TERMUX_PKG_REPLACES="gcc, libclang, libclang-dev, libllvm-dev"
TERMUX_PKG_GROUPS="base-devel"

# See https://llvm.org/docs/CMake.html:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DANDROID_PLATFORM_LEVEL=$TERMUX_PKG_API_LEVEL
-DPYTHON_EXECUTABLE=$(command -v "python${TERMUX_PYTHON_VERSION}")
-DLLVM_ENABLE_PIC=ON
-DLLVM_ENABLE_LIBEDIT=OFF
-DLLVM_INCLUDE_TESTS=OFF
-DCLANG_DEFAULT_CXX_STDLIB=libc++
-DCLANG_DEFAULT_LINKER=lld
-DCLANG_INCLUDE_TESTS=OFF
-DCLANG_TOOL_C_INDEX_TEST_BUILD=OFF
-DCOMPILER_RT_USE_BUILTINS_LIBRARY=ON
-DLLVM_LINK_LLVM_DYLIB=ON
-DLLDB_ENABLE_PYTHON=ON
-DLLDB_PYTHON_RELATIVE_PATH=lib/python${TERMUX_PYTHON_VERSION}/site-packages
-DLLDB_PYTHON_EXE_RELATIVE_PATH=bin/python${TERMUX_PYTHON_VERSION}
-DLLDB_PYTHON_EXT_SUFFIX=.cpython-${TERMUX_PYTHON_VERSION//./}.so
-DLLVM_NATIVE_TOOL_DIR=$TERMUX_PKG_HOSTBUILD_DIR/bin
-DCROSS_TOOLCHAIN_FLAGS_LLVM_NATIVE=-DLLVM_NATIVE_TOOL_DIR=$TERMUX_PKG_HOSTBUILD_DIR/bin
-DLIBOMP_ENABLE_SHARED=FALSE
-DOPENMP_ENABLE_LIBOMPTARGET=OFF
-DLLVM_ENABLE_SPHINX=ON
-DSPHINX_OUTPUT_MAN=ON
-DSPHINX_WARNINGS_AS_ERRORS=OFF
-DLLVM_TARGETS_TO_BUILD=all
-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=ARC;CSKY;M68k;VE
-DPERL_EXECUTABLE=$(command -v perl)
-DLLVM_ENABLE_FFI=ON
-DLLVM_ENABLE_RTTI=ON
-DLLVM_INSTALL_UTILS=ON
-DMLIR_INSTALL_AGGREGATE_OBJECTS=OFF
"

if (( TERMUX_ARCH_BITS == 32 )); then
	# Do not set _FILE_OFFSET_BITS=64
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_FORCE_SMALLFILE_FOR_ANDROID=on"
fi

TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_HAS_DEBUG=false
# Debug build succeeds but make install with:
# cp: cannot stat '../src/projects/openmp/runtime/exports/common.min.50.ompt.optional/include/omp.h': No such file or directory
# common.min.50.ompt.optional should be common.deb.50.ompt.optional when doing debug build

# shellcheck disable=SC2030,2031
termux_step_post_get_source() {
	# Version guard to keep flang in sync
	local flang_version flang_revision
	flang_version="$(. "$TERMUX_SCRIPTDIR/packages/flang/build.sh"; echo "${TERMUX_PKG_VERSION}")"
	flang_revision="$(TERMUX_PKG_REVISION=0; . "$TERMUX_SCRIPTDIR/packages/flang/build.sh"; echo "${TERMUX_PKG_REVISION}")"
	if [[ "${flang_version}-${flang_revision}" != "${TERMUX_PKG_VERSION}-${TERMUX_PKG_REVISION:-0}" ]]; then
		termux_error_exit "Version mismatch between libllvm and flang. libllvm=$TERMUX_PKG_VERSION-$TERMUX_PKG_REVISION, flang=$flang_version-$flang_revision"
	fi
}

# shellcheck disable=SC2031
termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	cmake -G Ninja -DCMAKE_BUILD_TYPE=Release \
		-DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra;lldb;mlir' "$TERMUX_PKG_SRCDIR/llvm"
	ninja -j "$TERMUX_PKG_MAKE_PROCESSES" clang-tblgen clang-tidy-confusable-chars-gen \
		lldb-tblgen llvm-tblgen mlir-tblgen mlir-linalg-ods-yaml-gen
}

# shellcheck disable=SC2031
termux_step_pre_configure() {
	# Add unknown vendor, otherwise it screws with the default LLVM triple
	# detection.
	local llvm_default_target_triple="${CCTERMUX_HOST_PLATFORM/-/-unknown-}"
	local llvm_target_arch
	case "$TERMUX_ARCH" in
		"aarch64") llvm_target_arch="AArch64";;
		"arm") llvm_target_arch="ARM";;
		"i686"|"x86_64") llvm_target_arch="X86";;
		*) termux_error_exit "Invalid arch: $TERMUX_ARCH";;
	esac

	local default_sysroot
	if [[ "$TERMUX__PREFIX" == "$TERMUX__ROOTFS" ]]; then
		default_sysroot=".."
	else
		default_sysroot="../.."
	fi
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DDEFAULT_SYSROOT=$default_sysroot"

	local llvm_projects="clang;clang-tools-extra;compiler-rt;lld;lldb;mlir;openmp;polly"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_ENABLE_PROJECTS=$llvm_projects"

	# see CMakeLists.txt and tools/clang/CMakeLists.txt
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_TARGET_ARCH=$llvm_target_arch"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_HOST_TRIPLE=$llvm_default_target_triple"
	export TERMUX_SRCDIR_SAVE="$TERMUX_PKG_SRCDIR"
	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR/llvm"
}

termux_step_post_configure() {
	TERMUX_PKG_SRCDIR="$TERMUX_SRCDIR_SAVE"
	unset TERMUX_SRCDIR_SAVE
}

# shellcheck disable=SC2031
termux_step_post_make_install() {
	if [[ "$TERMUX_PKG_CMAKE_BUILD" == "Ninja" ]]; then
		ninja -j "$TERMUX_PKG_MAKE_PROCESSES" docs-{llvm,clang}-man
	else
		make -j "$TERMUX_PKG_MAKE_PROCESSES" docs-{llvm,clang}-man
	fi

	cp docs/man/* "$TERMUX_PREFIX/share/man/man1"
	cp tools/clang/docs/man/{clang,diagtool}.1 "$TERMUX_PREFIX/share/man/man1"
	cd "$TERMUX_PREFIX/bin" || termux_error_exit "failed to change into 'bin' directory"


	for tool in clang clang++ cc c++ cpp gcc g++; do
		ln -f -s "clang-${TERMUX_PKG_VERSION%%.*}" "$tool"
	done

	ln -f -s clang++ "clang++-${TERMUX_PKG_VERSION%%.*}"
	ln -f -s "${TERMUX_PKG_VERSION%%.*}" "$TERMUX_PREFIX/lib/clang/latest"

	# Instead of symlinks, for executables named after target triplets, create the same type of
	# wrapper that the cross-compiling NDK uses to choose the correct target, including the API level
	local target="$CCTERMUX_HOST_PLATFORM"
	if [[ "$TERMUX_ARCH" == "arm" ]]; then
		target="armv7a-linux-androideabi$TERMUX_PKG_API_LEVEL"
	fi

	for tool in clang clang++ cpp gcc g++; do
		local wrapper="${TERMUX_HOST_PLATFORM}-${tool}"
		rm -f "$wrapper"
		cat <<- EOF > "$wrapper"
		#!$TERMUX_PREFIX/bin/bash
		if [ "\$1" != "-cc1" ]; then
			"\$(dirname \$0)/$tool" --target="$target" "\$@"
		else
			# Target is already an argument.
			"\$(dirname \$0)/$tool" "\$@"
		fi
		EOF
		chmod u+x "$wrapper"
	done
}

# shellcheck disable=SC2031
termux_step_pre_massage() {
	[[ "$TERMUX_PACKAGE_FORMAT" != "pacman" ]] && return
	sed -i "s|@LLVM_MAJOR_VERSION@|${TERMUX_PKG_VERSION%%.*}|g" ./share/libalpm/scripts/update-libcompiler-rt
}

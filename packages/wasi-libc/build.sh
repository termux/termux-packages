TERMUX_PKG_HOMEPAGE=https://wasi.dev/
TERMUX_PKG_DESCRIPTION="Libc for WebAssembly programs built on top of WASI system calls"
TERMUX_PKG_LICENSE="Apache-2.0, BSD 2-Clause, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE, src/wasi-libc/LICENSE-MIT, src/wasi-libc/libc-bottom-half/cloudlibc/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="30"
TERMUX_PKG_SRCURL=git+https://github.com/WebAssembly/wasi-sdk
TERMUX_PKG_GIT_BRANCH=wasi-sdk-${TERMUX_PKG_VERSION}
TERMUX_PKG_RECOMMENDS="wasm-component-ld"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+"

termux_step_post_get_source() {
	# match "clang -print-resource-dir"
	local p="${TERMUX_PKG_BUILDER_DIR}/0001-move-clang-resource-dir.diff"
	echo "Applying patch: $(basename "${p}")"
	sed "s|@LLVM_MAJOR_VERSION@|${TERMUX_LLVM_MAJOR_VERSION}|g" "${p}" \
		| patch -p1 --silent
}

termux_step_host_build() {
	# https://github.com/WebAssembly/wasi-sdk/blob/main/CMakeLists.txt
	termux_setup_cmake
	termux_setup_ninja
	termux_setup_rust

	cmake \
		-G Ninja \
		-S "${TERMUX_PKG_SRCDIR}" \
		-B "${TERMUX_PKG_HOSTBUILD_DIR}/toolchain" \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX="${TERMUX_PKG_HOSTBUILD_DIR}/install" \
		-DWASI_SDK_BUILD_TOOLCHAIN=ON
	ninja \
		-C "${TERMUX_PKG_HOSTBUILD_DIR}/toolchain" \
		-j "${TERMUX_PKG_MAKE_PROCESSES}" \
		install

	cmake \
		-G Ninja \
		-S "${TERMUX_PKG_SRCDIR}" \
		-B "${TERMUX_PKG_HOSTBUILD_DIR}/sysroot" \
		-DCMAKE_C_COMPILER_WORKS=ON \
		-DCMAKE_CXX_COMPILER_WORKS=ON \
		-DCMAKE_INSTALL_PREFIX="${TERMUX_PREFIX}" \
		-DCMAKE_TOOLCHAIN_FILE="${TERMUX_PKG_HOSTBUILD_DIR}/install/share/cmake/wasi-sdk.cmake"
	ninja \
		-C "${TERMUX_PKG_HOSTBUILD_DIR}/sysroot" \
		-j "${TERMUX_PKG_MAKE_PROCESSES}" \
		install

	# not installed by "ninja install"
	mkdir -p "${TERMUX_PREFIX}/share/cmake/Platform"
	mv -v "${TERMUX_PKG_HOSTBUILD_DIR}"/install/share/cmake/Platform/*.cmake "${TERMUX_PREFIX}/share/cmake/Platform/"
	mv -v "${TERMUX_PKG_HOSTBUILD_DIR}"/install/share/cmake/*.cmake "${TERMUX_PREFIX}/share/cmake/"

	local LLVM_MAJOR_VERSION_UPSTREAM
	LLVM_MAJOR_VERSION_UPSTREAM="$(grep llvm-version "${TERMUX_PREFIX}/share/wasi-sysroot/VERSION" | cut -d" " -f2 | cut -d"." -f1)"
	echo "INFO: LLVM_MAJOR_VERSION_UPSTREAM = $LLVM_MAJOR_VERSION_UPSTREAM"
	echo "INFO: LLVM_MAJOR_VERSION          = $TERMUX_LLVM_MAJOR_VERSION"
	if [[ "${LLVM_MAJOR_VERSION_UPSTREAM}" != "${TERMUX_LLVM_MAJOR_VERSION}" ]]; then
		echo "WARN: Version mismatch! Termux clang may not work with wasi-libc sysroot!" 1>&2
	fi
}

termux_step_configure() {
	# always remove this marker because this package is built in termux_step_host_build()
	# this prevents "ERROR: No files in package." when the package is built again without deleting
	# the docker container.
	rm -rf $TERMUX_HOSTBUILD_MARKER
	# also, termux_step_configure() does not do anything else for this package
}

termux_step_make() {
	:
}

termux_step_make_install() {
	:
}

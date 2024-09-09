TERMUX_PKG_HOMEPAGE=https://wasi.dev/
TERMUX_PKG_DESCRIPTION="Libc for WebAssembly programs built on top of WASI system calls"
TERMUX_PKG_LICENSE="Apache-2.0, BSD 2-Clause, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE, src/wasi-libc/LICENSE-MIT, src/wasi-libc/libc-bottom-half/cloudlibc/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="24"
TERMUX_PKG_SRCURL=git+https://github.com/WebAssembly/wasi-sdk
TERMUX_PKG_GIT_BRANCH=wasi-sdk-${TERMUX_PKG_VERSION}
TERMUX_PKG_RECOMMENDS="wasm-component-ld"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+"

termux_pkg_auto_update() {
	local api_url="https://api.github.com/repos/WebAssembly/wasi-sdk/git/refs/tags"
	local latest_refs_tags=$(curl -s "${api_url}" | jq .[].ref | grep -oP wasi-sdk-${TERMUX_PKG_UPDATE_VERSION_REGEXP})
	if [[ -z "${latest_refs_tags}" ]]; then
		echo "WARN: Unable to get latest refs tags from upstream. Try again later." >&2
		return
	fi
	local latest_version=$(echo "${latest_refs_tags}" | sort -V | tail -n1)
	termux_pkg_upgrade_version "${latest_version}"
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
		-DWASI_SDK_BUILD_TOOLCHAIN=ON \
		-DCMAKE_INSTALL_PREFIX="${TERMUX_PKG_HOSTBUILD_DIR}/install"
	ninja \
		-C "${TERMUX_PKG_HOSTBUILD_DIR}/toolchain" \
		-j "${TERMUX_PKG_MAKE_PROCESSES}" \
		install

	cmake \
		-G Ninja \
		-S "${TERMUX_PKG_SRCDIR}" \
		-B "${TERMUX_PKG_HOSTBUILD_DIR}/sysroot" \
		-DCMAKE_INSTALL_PREFIX="${TERMUX_PREFIX}" \
		-DCMAKE_TOOLCHAIN_FILE="${TERMUX_PKG_HOSTBUILD_DIR}/install/share/cmake/wasi-sdk.cmake" \
		-DCMAKE_C_COMPILER_WORKS=ON \
		-DCMAKE_CXX_COMPILER_WORKS=ON
	ninja \
		-C ${TERMUX_PKG_HOSTBUILD_DIR}/sysroot \
		-j ${TERMUX_PKG_MAKE_PROCESSES} \
		install

	mkdir -p "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}"
	mv -v "${TERMUX_PREFIX}/VERSION" "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}"
	echo "INFO: ${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}/VERSION"
	cat "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}/VERSION"
	echo

	mv -v "${TERMUX_PKG_HOSTBUILD_DIR}/install/share/cmake" "${TERMUX_PREFIX}/share"

	local llvm_major_version=$(grep llvm-version "${TERMUX_PREFIX}/share/wasi-sysroot/VERSION" | cut -d" " -f2 | cut -d"." -f1)
	mkdir -p "${TERMUX_PREFIX}/lib/clang/${llvm_major_version}/lib"
	mv -v "${TERMUX_PREFIX}/clang-resource-dir/lib" "${TERMUX_PREFIX}/lib/clang/${llvm_major_version}"
	rm -frv "${TERMUX_PREFIX}/clang-resource-dir"
}

termux_step_make() {
	:
}

termux_step_make_install() {
	:
}

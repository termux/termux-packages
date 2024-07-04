TERMUX_PKG_HOMEPAGE=https://wasi.dev/
TERMUX_PKG_DESCRIPTION="Libc for WebAssembly programs built on top of WASI system calls"
TERMUX_PKG_LICENSE="Apache-2.0, BSD 2-Clause, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE, src/wasi-libc/LICENSE-MIT, src/wasi-libc/libc-bottom-half/cloudlibc/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="22"
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
	# https://github.com/WebAssembly/wasi-sdk/blob/main/Makefile
	termux_setup_cmake
	termux_setup_ninja
	termux_setup_rust

	pushd "${TERMUX_PKG_BUILDDIR}"
	mkdir -p "build/install/${TERMUX_PREFIX#/}"
	make -j "${TERMUX_PKG_MAKE_PROCESSES}" build NINJA_FLAGS="-j ${TERMUX_PKG_MAKE_PROCESSES}"
	echo "${PWD}/build/install/${TERMUX_PREFIX#/}/VERSION"
	cat "${PWD}/build/install/${TERMUX_PREFIX#/}/VERSION"
	popd
}

termux_step_make() {
	:
}

termux_step_make_install() {
	# use our own LLVM, autoconf config.guess, wasm-component-ld
	local llvm_major_version=$(grep llvm-version "build/install/${TERMUX_PREFIX#/}/VERSION" | cut -d" " -f2 | sed "s|\..*||")
	mkdir -p "${TERMUX_PREFIX}/lib/clang/${llvm_major_version}"
	cp -fr "build/install/${TERMUX_PREFIX#/}/lib/clang/${llvm_major_version}/lib" "${TERMUX_PREFIX}/lib/clang/${llvm_major_version}"
	cp -fr "build/install/${TERMUX_PREFIX#/}/share/cmake" "${TERMUX_PREFIX}/share"
	cp -fr "build/install/${TERMUX_PREFIX#/}/share/wasi-sysroot" "${TERMUX_PREFIX}/share"
}

TERMUX_PKG_HOMEPAGE=https://tinygo.org
TERMUX_PKG_DESCRIPTION="Go compiler for microcontrollers, WASM, CLI tools"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.31.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/tinygo-org/tinygo
TERMUX_PKG_GIT_BRANCH="v${TERMUX_PKG_VERSION}"
TERMUX_PKG_SHA256=cb5e95fe40ea983ded57730a4abcb194439a657a84041787733a6227a8fd1700
TERMUX_PKG_DEPENDS="binaryen, golang, libc++"
TERMUX_PKG_ANTI_BUILD_DEPENDS="binaryen, golang"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_AUTO_UPDATE=true
_LLVM_OPTION="
-DCMAKE_BUILD_TYPE=MinSizeRel
-DGENERATOR_IS_MULTI_CONFIG=ON
-DLLVM_ENABLE_LTO=Thin
-DLLVM_TABLEGEN=${TERMUX_PKG_HOSTBUILD_DIR}/bin/llvm-tblgen
-DCLANG_TABLEGEN=${TERMUX_PKG_HOSTBUILD_DIR}/bin/clang-tblgen
"
_LLVM_EXTRA_BUILD_TARGETS="
lib/libLLVMDWARFLinker.a
lib/libLLVMDWARFLinkerParallel.a
lib/libLLVMDWP.a
lib/libLLVMDebugInfoGSYM.a
lib/libLLVMDebugInfoLogicalView.a
lib/libLLVMFileCheck.a
lib/libLLVMFrontendOpenACC.a
lib/libLLVMFuzzMutate.a
lib/libLLVMFuzzerCLI.a
lib/libLLVMInterfaceStub.a
lib/libLLVMJITLink.a
lib/libLLVMLineEditor.a
lib/libLLVMMIRParser.a
lib/libLLVMObjCopy.a
lib/libLLVMObjectYAML.a
lib/libLLVMOrcJIT.a
lib/libLLVMXRay.a
"

termux_pkg_auto_update() {
	local e=0
	local latest_tag
	latest_tag=$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}" "${TERMUX_PKG_UPDATE_TAG_TYPE}")
	if [[ "${latest_tag}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi
	[[ -z "${latest_tag}" ]] && e=1

	local uptime_now=$(cat /proc/uptime)
	local uptime_s="${uptime_now//.*}"
	local uptime_h_limit=1
	local uptime_s_limit=$((uptime_h_limit*60*60))
	[[ -z "${uptime_s}" ]] && e=1
	[[ "${uptime_s}" == 0 ]] && e=1
	[[ "${uptime_s}" -gt "${uptime_s_limit}" ]] && e=1

	if [[ "${e}" != 0 ]]; then
		cat <<- EOL >&2
		WARN: Auto update failure!
		latest_tag=${latest_tag}
		uptime_now=${uptime_now}
		uptime_s=${uptime_s}
		uptime_s_limit=${uptime_s_limit}
		EOL
		return
	fi

	local tmpdir=$(mktemp -d)
	git clone --branch "v${latest_tag}" --depth=1 --recursive \
		"${TERMUX_PKG_SRCURL#git+}" "${tmpdir}"
	make -C "${tmpdir}" llvm-source GO=:
	local s=$(
		find "${tmpdir}" -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | \
		cut -d" " -f1 | LC_ALL=C sort | sha256sum | cut -d" " -f1
	)

	sed \
		-e "s|^TERMUX_PKG_SHA256=.*|TERMUX_PKG_SHA256=${s}|" \
		-i "${TERMUX_PKG_BUILDER_DIR}/build.sh"

	rm -fr "${tmpdir}"

	echo "INFO: Generated checksum: ${s}"
	termux_pkg_upgrade_version "${latest_tag}"
}

termux_step_post_get_source() {
	# https://github.com/tinygo-org/tinygo/blob/release/Makefile
	# https://github.com/espressif/llvm-project
	make llvm-source GO=:

	local s=$(
		find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | \
		cut -d" " -f1 | LC_ALL=C sort | sha256sum | cut -d" " -f1
	)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}" ]]; then
		termux_error_exit "
		Checksum mismatch for source files!
		Expected = ${TERMUX_PKG_SHA256}
		Actual   = ${s}
		"
	fi
}

termux_step_host_build() {
	termux_setup_golang
	termux_setup_cmake
	termux_setup_ninja

	pushd "${TERMUX_PKG_SRCDIR}"
	make "${TERMUX_PKG_HOSTBUILD_DIR}" \
		LLVM_BUILDDIR="${TERMUX_PKG_HOSTBUILD_DIR}"

	# build whatever llvm-config think is missing
	ninja \
		-C "${TERMUX_PKG_HOSTBUILD_DIR}" \
		-j "${TERMUX_MAKE_PROCESSES}" \
		${_LLVM_EXTRA_BUILD_TARGETS}

	echo "===== llvm-config ====="
	file "${TERMUX_PKG_HOSTBUILD_DIR}/bin/llvm-config"
	"${TERMUX_PKG_HOSTBUILD_DIR}/bin/llvm-config" --cppflags
	"${TERMUX_PKG_HOSTBUILD_DIR}/bin/llvm-config" --ldflags --libs --system-libs
	echo "===== llvm-config ====="

	make build/release \
		LLVM_BUILDDIR="${TERMUX_PKG_HOSTBUILD_DIR}" \
		CLANG="${TERMUX_PKG_HOSTBUILD_DIR}/bin/clang" \
		LLVM_AR="${TERMUX_PKG_HOSTBUILD_DIR}/bin/llvm-ar" \
		LLVM_NM="${TERMUX_PKG_HOSTBUILD_DIR}/bin/llvm-nm" \
		USE_SYSTEM_BINARYEN=1
	popd
}

termux_step_pre_configure() {
	# this is a workaround for build-all.sh issue
	TERMUX_PKG_DEPENDS+=", tinygo-common"

	# https://github.com/termux/termux-packages/issues/16358
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then
		echo "WARN: ld.lld wrapper is not working for on-device builds. Skipping."
		return
	fi

	local _WRAPPER_BIN=${TERMUX_PKG_BUILDDIR}/_wrapper/bin
	mkdir -p "${_WRAPPER_BIN}"
	ln -fs "${TERMUX_STANDALONE_TOOLCHAIN}/bin/lld" "${_WRAPPER_BIN}/ld.lld"
	cat <<- EOF > "${_WRAPPER_BIN}/ld.lld.sh"
	#!/bin/bash
	tmpfile=\$(mktemp)
	python ${TERMUX_PKG_BUILDER_DIR}/fix-rpath.py -rpath=${TERMUX_PREFIX}/lib \$@ > \${tmpfile}
	args=\$(cat \${tmpfile})
	rm -f \${tmpfile}
	${_WRAPPER_BIN}/ld.lld \${args}
	EOF
	chmod +x "${_WRAPPER_BIN}/ld.lld.sh"
	rm -f "${TERMUX_STANDALONE_TOOLCHAIN}/bin/ld.lld"
	ln -fs "${_WRAPPER_BIN}/ld.lld.sh" "${TERMUX_STANDALONE_TOOLCHAIN}/bin/ld.lld"
}

termux_step_make() {
	termux_setup_golang
	termux_setup_cmake
	termux_setup_ninja

	# from packages/libllvm/build.sh
	local _LLVM_TARGET_TRIPLE=${TERMUX_HOST_PLATFORM/-/-unknown-}${TERMUX_PKG_API_LEVEL}
	local _LLVM_TARGET_ARCH
	case "${TERMUX_ARCH}" in
	aarch64) _LLVM_TARGET_ARCH="AArch64" ;;
	arm) _LLVM_TARGET_ARCH="ARM" ;;
	i686|x86_64) _LLVM_TARGET_ARCH="X86" ;;
	*) termux_error_exit "Invalid arch: ${TERMUX_ARCH}" ;;
	esac
	_LLVM_OPTION+="
	-DLLVM_HOST_TRIPLE=${_LLVM_TARGET_TRIPLE}
	-DLLVM_TARGET_ARCH=${_LLVM_TARGET_ARCH}
	"

	make llvm-build LLVM_OPTION="$(echo ${_LLVM_OPTION})"

	ninja \
		-C llvm-build \
		-j "${TERMUX_MAKE_PROCESSES}" \
		${_LLVM_EXTRA_BUILD_TARGETS}

	# replace Android llvm-config with wrapper around host build
	cat <<- EOF > llvm-build/bin/llvm-config
	#!/bin/bash
	${TERMUX_PKG_HOSTBUILD_DIR}/bin/llvm-config "\$@" | \
	sed \
	-e "s|${TERMUX_PKG_HOSTBUILD_DIR}|${TERMUX_PKG_SRCDIR}/llvm-build|g" \
	-e "s|-lrt|-lc|g"
	EOF

	make tinygo
	mkdir -p build/release/tinygo/bin
	cp -fv build/tinygo build/release/tinygo/bin

	# skip make gen-device, done in host build
	# skip make wasi-libc, NDK doesnt support wasm32-unknown-wasi
	# skip make binaryen

	# check excessive runpath entries
	local tinygo_readelf=$(readelf -dW build/release/tinygo/bin/tinygo)
	local tinygo_runpath=$(echo "${tinygo_readelf}" | sed -ne "s|.*RUNPATH.*\[\(.*\)\].*|\1|p")
	if [[ "${tinygo_runpath}" != "${TERMUX_PREFIX}/lib" ]]; then
		termux_error_exit "
		Excessive RUNPATH found. Check readelf output below:
		${tinygo_readelf}
		"
	fi
}

termux_step_make_install() {
	mkdir -p "${TERMUX_PREFIX}/lib/tinygo"
	cp -fr "${TERMUX_PKG_SRCDIR}/build/release/tinygo" "${TERMUX_PREFIX}/lib"
	ln -fsv "../lib/tinygo/bin/tinygo" "${TERMUX_PREFIX}/bin/tinygo"
}

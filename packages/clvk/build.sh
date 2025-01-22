TERMUX_PKG_HOMEPAGE=https://github.com/kpet/clvk
TERMUX_PKG_DESCRIPTION="Experimental implementation of OpenCL on Vulkan"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=a91d6a8092592f99971e6cd68fed8ecd57f19700
_COMMIT_DATE=20250121
_COMMIT_TIME=215854
TERMUX_PKG_VERSION="0.0.20250121.215854"
TERMUX_PKG_SRCURL=git+https://github.com/kpet/clvk
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_BUILD_DEPENDS="vulkan-headers, vulkan-loader-android"
TERMUX_PKG_DEPENDS="libc++, vulkan-loader"
TERMUX_PKG_ANTI_BUILD_DEPENDS="vulkan-loader"
TERMUX_PKG_RECOMMENDS="ocl-icd"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCLSPV_EXTERNAL_LIBCLC_DIR=${TERMUX_PKG_HOSTBUILD_DIR}/libclc
-DCLVK_BUILD_TESTS=ON
-DCLVK_CLSPV_ONLINE_COMPILER=ON
-DCLVK_VULKAN_IMPLEMENTATION=custom
-DLLVM_INCLUDE_BENCHMARKS=OFF
-DLLVM_INCLUDE_EXAMPLES=OFF
-DLLVM_NATIVE_TOOL_DIR=${TERMUX_PKG_HOSTBUILD_DIR}/llvm/bin
-DVulkan_INCLUDE_DIRS=${TERMUX_PREFIX}/include
"

termux_pkg_auto_update() {
	local api_url="https://api.github.com/repos/kpet/clvk/commits"
	local latest_commit=$(curl -s "${api_url}"| jq .[].sha | head -n1 | sed -e 's|\"||g')
	if [[ -z "${latest_commit}" ]]; then
		echo "WARN: Unable to get latest commit from upstream" >&2
		return
	fi
	if [[ "${latest_commit}" == "${_COMMIT}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	local latest_commit_date_tz=$(curl -s "${api_url}/${latest_commit}" | jq .commit.committer.date | sed -e 's|\"||g')
	if [[ -z "${latest_commit_date_tz}" ]]; then
		termux_error_exit "ERROR: Unable to get latest commit date info"
	fi

	local latest_commit_date=$(echo "${latest_commit_date_tz}" | sed -e 's|\(.*\)T\(.*\)Z|\1|' -e 's|\-||g')
	local latest_commit_time=$(echo "${latest_commit_date_tz}" | sed -e 's|\(.*\)T\(.*\)Z|\2|' -e 's|\:||g')

	# https://github.com/termux/termux-packages/issues/11827
	local latest_version="0.0.${latest_commit_date}.${latest_commit_time}"

	local current_date_epoch=$(date "+%s")
	local _COMMIT_DATE_epoch=$(date -d "${_COMMIT_DATE}" "+%s")
	local current_date_diff=$(((current_date_epoch-_COMMIT_DATE_epoch)/(60*60*24)))
	local cooldown_days=14
	if [[ "${current_date_diff}" -lt "${cooldown_days}" ]]; then
		cat <<- EOL
		INFO: Queuing updates since last push
		Cooldown (days) = ${cooldown_days}
		Days since      = ${current_date_diff}
		EOL
		return
	fi

	if ! dpkg --compare-versions "${latest_version}" gt "${TERMUX_PKG_VERSION}"; then
		termux_error_exit "
		ERROR: Resulting latest version is not counted as an update!
		Latest version  = ${latest_version}
		Current version = ${TERMUX_PKG_VERSION}
		"
	fi

	# unlikely to happen
	if [[ "${latest_commit_date}" -lt "${_COMMIT_DATE}" || \
		"${latest_commit_date}" -eq "${_COMMIT_DATE}" && "${latest_commit_time}" -lt "${_COMMIT_TIME}" ]]; then
		termux_error_exit "
		ERROR: Upstream is older than current package version!
		ERROR: Please report to upstream!
		"
	fi

	sed \
		-e "s|^_COMMIT=.*|_COMMIT=${latest_commit}|" \
		-e "s|^_COMMIT_DATE=.*|_COMMIT_DATE=${latest_commit_date}|" \
		-e "s|^_COMMIT_TIME=.*|_COMMIT_TIME=${latest_commit_time}|" \
		-i "${TERMUX_PKG_BUILDER_DIR}/build.sh"

	termux_pkg_upgrade_version "${latest_version}" --skip-version-check
}

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout "${_COMMIT}"
	git submodule update --init --recursive --depth=1
	git clean -ffxd
	./external/clspv/utils/fetch_sources.py --deps llvm --shallow
}

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	local _LLVM_TARGET_ARCH
	case "${TERMUX_ARCH}" in
	aarch64) _LLVM_TARGET_ARCH="AArch64" ;;
	arm) _LLVM_TARGET_ARCH="ARM" ;;
	i686|x86_64) _LLVM_TARGET_ARCH="X86" ;;
	*) termux_error_exit "Invalid arch: ${TERMUX_ARCH}" ;;
	esac

	cmake \
		-G Ninja \
		-B "${TERMUX_PKG_HOSTBUILD_DIR}/llvm" \
		-S "${TERMUX_PKG_SRCDIR}/external/clspv/third_party/llvm/llvm" \
		-DCMAKE_BUILD_TYPE=Release \
		-DLLVM_INCLUDE_BENCHMARKS=OFF \
		-DLLVM_INCLUDE_EXAMPLES=OFF \
		-DLLVM_INCLUDE_TESTS=OFF \
		-DLLVM_INCLUDE_UTILS=OFF \
		-DLLVM_ENABLE_PROJECTS=clang \
		-DLLVM_TARGETS_TO_BUILD="${_LLVM_TARGET_ARCH}"
	ninja \
		-C "${TERMUX_PKG_HOSTBUILD_DIR}/llvm" \
		-j "${TERMUX_PKG_MAKE_PROCESSES}" \
		llvm-tblgen clang-tblgen
	cmake \
		-G Ninja \
		-B "${TERMUX_PKG_HOSTBUILD_DIR}/libclc" \
		-S "${TERMUX_PKG_SRCDIR}/external/clspv/third_party/llvm/libclc" \
		-DLIBCLC_TARGETS_TO_BUILD="clspv--;clspv64--"
	ninja \
		-C "${TERMUX_PKG_HOSTBUILD_DIR}/libclc" \
		-j "${TERMUX_PKG_MAKE_PROCESSES}"
}

termux_step_pre_configure() {
	local _libvulkan=vulkan
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" && "${TERMUX_PKG_API_LEVEL}" -lt 28 ]]; then
		_libvulkan="${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/lib/${TERMUX_HOST_PLATFORM}/28/libvulkan.so"
	fi
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DVulkan_LIBRARIES=${_libvulkan}"

	# from packages/libllvm/build.sh
	local _LLVM_TARGET_TRIPLE=${TERMUX_HOST_PLATFORM/-/-unknown-}${TERMUX_PKG_API_LEVEL}
	local _LLVM_TARGET_ARCH
	case "${TERMUX_ARCH}" in
	aarch64) _LLVM_TARGET_ARCH="AArch64" ;;
	arm) _LLVM_TARGET_ARCH="ARM" ;;
	i686|x86_64) _LLVM_TARGET_ARCH="X86" ;;
	*) termux_error_exit "Invalid arch: ${TERMUX_ARCH}" ;;
	esac
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
	-DLLVM_HOST_TRIPLE=${_LLVM_TARGET_TRIPLE}
	-DLLVM_TARGET_ARCH=${_LLVM_TARGET_ARCH}
	-DLLVM_TARGETS_TO_BUILD=${_LLVM_TARGET_ARCH}
	"

	export CFLAGS+=" -flto=thin"
	export CXXFLAGS+=" -flto=thin"

	# TERMUX_DEBUG_BUILD doesnt have middle ground
	#TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_BUILD_TYPE=RelWithDebInfo"
	#export STRIP=:
}

termux_step_make_install() {
	# clvk does not have proper install rule yet
	install -Dm644 -t "${TERMUX_PREFIX}/lib/clvk" "${TERMUX_PKG_BUILDDIR}/libOpenCL.so"

	echo "${TERMUX_PREFIX}/lib/clvk/libOpenCL.so" > "${TERMUX_PKG_TMPDIR}/clvk.icd"
	install -Dm644 -t "${TERMUX_PREFIX}/etc/OpenCL/vendors" "${TERMUX_PKG_TMPDIR}/clvk.icd"
}

# https://github.com/kpet/clvk/blob/main/CMakeLists.txt

# Known issues:
# https://github.com/kpet/clvk/issues/375
# https://github.com/kpet/clvk/issues/499
# https://github.com/kpet/clvk/issues/544
# https://github.com/termux/termux-packages/issues/11827

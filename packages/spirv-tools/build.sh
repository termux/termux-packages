TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/SPIRV-Tools
TERMUX_PKG_DESCRIPTION="SPIR-V Tools"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.280.0"
TERMUX_PKG_SRCURL=https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=703c772a850fa7fbe57a2f8dc99b4c1422a59fa5ff098a80c8ce12fcdf6a2613
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="spirv-headers (=${TERMUX_PKG_VERSION})"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+\.\d+"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DSPIRV-Headers_SOURCE_DIR=${TERMUX_PREFIX}
-DSPIRV_WERROR=OFF
"

termux_pkg_auto_update() {
	# use versions from sdk-* and not vYEAR.* to match spirv-headers
	local api_url="https://api.github.com/repos/KhronosGroup/SPIRV-Tools/git/refs/tags"
	local latest_refs_tags=$(curl -s "${api_url}" | jq .[].ref | grep -oP vulkan-sdk-${TERMUX_PKG_UPDATE_VERSION_REGEXP} | sort)
	if [[ -z "${latest_refs_tags}" ]]; then
		echo "WARN: Unable to get latest refs tags from upstream. Try again later." >&2
		return
	fi
	local latest_version=$(echo "${latest_refs_tags}" | tail -n1)
	termux_pkg_upgrade_version "${latest_version//vulkan-sdk-}"
}

TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/SPIRV-Tools
TERMUX_PKG_DESCRIPTION="SPIR-V Tools"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.290.0"
TERMUX_PKG_SRCURL=https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8f8b487e20e062c3abfbc86c4541faf767588d167b395ec94f2a7f996ef40efe
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
	local latest_refs_tags=$(curl -s "${api_url}" | jq .[].ref | grep -oP vulkan-sdk-${TERMUX_PKG_UPDATE_VERSION_REGEXP})
	if [[ -z "${latest_refs_tags}" ]]; then
		echo "WARN: Unable to get latest refs tags from upstream. Try again later." >&2
		return
	fi
	local latest_version=$(echo "${latest_refs_tags}" | sort -V | tail -n1)
	termux_pkg_upgrade_version "${latest_version//vulkan-sdk-}"
}

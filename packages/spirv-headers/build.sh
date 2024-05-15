TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/SPIRV-Headers
TERMUX_PKG_DESCRIPTION="SPIR-V Headers"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.283.0"
TERMUX_PKG_SRCURL=https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/vulkan-sdk-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a68a25996268841073c01514df7bab8f64e2db1945944b45087e5c40eed12cb9
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+\.\d+"

termux_pkg_auto_update() {
	local api_url="https://api.github.com/repos/KhronosGroup/SPIRV-Headers/git/refs/tags"
	local latest_refs_tags=$(curl -s "${api_url}" | jq .[].ref | grep -oP vulkan-sdk-${TERMUX_PKG_UPDATE_VERSION_REGEXP} | sort)
	if [[ -z "${latest_refs_tags}" ]]; then
		echo "WARN: Unable to get latest refs tags from upstream. Try again later." >&2
		return
	fi
	local latest_version=$(echo "${latest_refs_tags}" | tail -n1)
	termux_pkg_upgrade_version "${latest_version//vulkan-sdk-}"
}

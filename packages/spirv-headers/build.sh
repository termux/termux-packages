TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/SPIRV-Headers
TERMUX_PKG_DESCRIPTION="SPIR-V Headers"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.261.1"
TERMUX_PKG_SRCURL=https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/sdk-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=32b4c6ae6a2fa9b56c2c17233c8056da47e331f76e117729925825ea3e77a739
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true

termux_pkg_auto_update() {
	local e=0
	local api_url="https://api.github.com/repos/KhronosGroup/SPIRV-Headers/git/refs/tags"
	local api_url_r=$(curl -s "${api_url}")
	local r1=$(echo "${api_url_r}" | jq .[].ref | sed -nE "s|.*/(sdk-.*)\"|\1|p")
	local latest_version=$(echo "${r1}" | tail -n1)
	[[ -z "${api_url_r}" ]] && e=1
	[[ -z "${r1}" ]] && e=1
	[[ -z "${latest_version}" ]] && e=1

	if [[ "${e}" != 0 ]]; then
		cat <<- EOL >&2
		WARN: Auto update failure!
		api_url_r=${api_url_r}
		r1=${r1}
		latest_version=${latest_version}
		EOL
		return
	fi

	termux_pkg_upgrade_version "${latest_version//sdk-}"
}

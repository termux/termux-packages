TERMUX_PKG_HOMEPAGE=https://mediaarea.net/en/MediaInfo
TERMUX_PKG_DESCRIPTION="Command-line utility for reading information from media files"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="../../../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="24.05"
TERMUX_PKG_SRCURL=https://mediaarea.net/download/source/mediainfo/${TERMUX_PKG_VERSION}/mediainfo_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b6451edc3d1bf54c17218e8e950818cf0e7b4913e6da28e9119400526a8e89f0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libc++, libmediainfo, libzen"

termux_pkg_auto_update() {
	local e=0
	local api_url="https://mediaarea.net/en/MediaInfo"
	local api_url_r=$(curl -Ls "${api_url}/")
	local r1=$(echo "${api_url_r}" | grep -o '"softwareVersion"\s*:\s*"\([^"]\+\)"')
	local latest_version=$(echo "${r1}" | grep -o '[0-9.]\+')

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

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR="${TERMUX_PKG_SRCDIR}/Project/GNU/CLI"
	TERMUX_PKG_BUILDDIR="${TERMUX_PKG_SRCDIR}"
	cd "${TERMUX_PKG_SRCDIR}"
	./autogen.sh
}

TERMUX_PKG_HOMEPAGE=https://dev.yorhel.nl/ncdu
TERMUX_PKG_DESCRIPTION="Disk usage analyzer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="1.21"
TERMUX_PKG_SRCURL=https://dev.yorhel.nl/download/ncdu-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a894d3a9b46bce578a6039bef48f54533ec402fb589b0769bfbb1d1edf9601a6
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-shell=${TERMUX_PREFIX}/bin/sh
"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='1\.\d+(\.\d+)?'

termux_pkg_auto_update() {
	local latest_release
	latest_release="$(git ls-remote --tags https://code.blicky.net/yorhel/ncdu.git \
	| grep -oP "refs/tags/v\K${TERMUX_PKG_UPDATE_VERSION_REGEXP}$" \
	| sort -V \
	| tail -n1)"

	if [[ "${latest_release}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	termux_pkg_upgrade_version "${latest_release}"
}

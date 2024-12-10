TERMUX_PKG_HOMEPAGE=https://www.greenwoodsoftware.com/less/
TERMUX_PKG_DESCRIPTION="Terminal pager program used to view the contents of a text file one screen at a time"
# less has both the GPLv3 and its own "less license" which is a variation of a BSD 2-Clause license
TERMUX_PKG_LICENSE="GPL-3.0, custom"
TERMUX_PKG_LICENSE_FILE='COPYING, LICENSE'
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION=661
TERMUX_PKG_SRCURL=https://www.greenwoodsoftware.com/less/less-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2b5f0167216e3ef0ffcb0c31c374e287eb035e4e223d5dae315c2783b6e738ed
TERMUX_PKG_DEPENDS="ncurses, pcre2"
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-regex=pcre2"
# Official `less` release tags are marked with a `-rel` suffix
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d{3}-rel'

termux_pkg_auto_update() {
	local latest_release
	latest_release="$(git ls-remote --tags https://github.com/gwsw/less.git \
	| grep -oP "refs/tags/v\K${TERMUX_PKG_UPDATE_VERSION_REGEXP}$" \
	| sort -V \
	| tail -n1)"

	# remove `-rel` suffix from version number
	latest_release="${latest_release%-rel}"
	if [[ "${latest_release}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	# Avoid refiltering the version number
	# See: https://github.com/termux/termux-packages/issues/20836
	unset TERMUX_PKG_UPDATE_VERSION_REGEXP
	termux_pkg_upgrade_version "${latest_release}"
}



termux_step_pre_configure() {
	autoreconf -fi
}

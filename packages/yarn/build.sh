TERMUX_PKG_HOMEPAGE=https://classic.yarnpkg.com/lang/en/
TERMUX_PKG_DESCRIPTION="Fast, reliable, and secure dependency management"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.22.22"
TERMUX_PKG_SRCURL=https://yarnpkg.com/downloads/${TERMUX_PKG_VERSION}/yarn-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=88268464199d1611fcf73ce9c0a6c4d44c7d5363682720d8506f6508addf36a0
TERMUX_PKG_DEPENDS="nodejs | nodejs-lts"
TERMUX_PKG_ANTI_BUILD_DEPENDS="nodejs, nodejs-lts"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true

termux_pkg_auto_update() {
	local api_url="https://api.github.com/repos/yarnpkg/yarn/git/refs/tags"
	local latest_refs_tags=$(curl -s "${api_url}" | jq .[].ref | sed -ne "s|.*v\(.*\)\"|\1|p")
	if [[ -z "${latest_refs_tags}" ]]; then
		echo "WARN: Unable to get latest refs tags from upstream. Try again later." >&2
		return
	fi
	local latest_version=$(echo "${latest_refs_tags}" | sort -V | tail -n1)

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_make_install() {
	cp -r . ${TERMUX_PREFIX}/share/yarn/
	ln -fs ../share/yarn/bin/yarn ${TERMUX_PREFIX}/bin/yarn
	ln -fs ../share/yarn/bin/yarn ${TERMUX_PREFIX}/bin/yarnpkg
}

# Termux will not package yarn-berry
# https://github.com/termux/termux-packages/issues/19407
# https://github.com/yarnpkg/berry/discussions/5629#discussioncomment-6593555

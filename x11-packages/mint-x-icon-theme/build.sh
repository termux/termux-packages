TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/mint-x-icons
TERMUX_PKG_DESCRIPTION="The Mint-X icon theme for cinnamon"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.3"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/linuxmint/mint-x-icons/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=51356478ed0bd22ef3c71ea085f52e0bfb059dd327680c434fa31760812baed7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="hicolor-icon-theme, adwaita-icon-theme, adwaita-icon-theme-legacy, gtk-update-icon-cache"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_pkg_auto_update() {
	local latest_release
	latest_release="$(git ls-remote --tags "$TERMUX_PKG_HOMEPAGE.git" \
		| grep -oP "refs/tags/\K${TERMUX_PKG_UPDATE_VERSION_REGEXP}$" \
		| sort -V \
		| tail -n1)"

	if [[ "${latest_release}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	termux_pkg_upgrade_version "${latest_release}"
}

termux_step_make_install() {
	cp -r $TERMUX_PKG_SRCDIR/usr/* $TERMUX_PREFIX/
}

TERMUX_PKG_HOMEPAGE=https://github.com/vinceliuice/Fluent-icon-theme
TERMUX_PKG_DESCRIPTION="Fluent icon theme for linux desktops"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.07.27"
TERMUX_PKG_SRCURL=https://github.com/vinceliuice/Fluent-icon-theme/archive/refs/tags/${TERMUX_PKG_VERSION//./-}.tar.gz
TERMUX_PKG_SHA256=24a8aca29a5b652a0e60ff8e5f12b86fe4b9c4c969565fad7c3fa7c1742b3631
TERMUX_PKG_DEPENDS="hicolor-icon-theme"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_RM_AFTER_INSTALL="share/icons/*/icon-theme.cache"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP='s/-/./g'
TERMUX_PKG_REPOLOGY_METADATA_VERSION="${TERMUX_PKG_VERSION//./}"

termux_step_make_install(){
	./install.sh -d ${TERMUX_PREFIX}/share/icons
}

TERMUX_PKG_HOMEPAGE=https://github.com/lxde/lxmenu-data
TERMUX_PKG_DESCRIPTION="Freedesktop.org desktop menus for LXDE"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.7"
TERMUX_PKG_SRCURL=https://github.com/lxde/lxmenu-data/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9f601c68f6e993451587dd422e352aa5478b7f584947587d38773f329b9b6ab4
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	./autogen.sh
}

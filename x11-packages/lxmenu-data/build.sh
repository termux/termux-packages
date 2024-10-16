TERMUX_PKG_HOMEPAGE=https://github.com/lxde/lxmenu-data
TERMUX_PKG_DESCRIPTION="Freedesktop.org desktop menus for LXDE"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.6"
TERMUX_PKG_SRCURL=https://github.com/lxde/lxmenu-data/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b237e732609fb2a521a942e08bb825ac7973ee478db7567d3606665a3793b2e8
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	./autogen.sh
}

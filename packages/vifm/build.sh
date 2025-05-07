TERMUX_PKG_HOMEPAGE=https://vifm.info/
TERMUX_PKG_DESCRIPTION="File manager with vi like keybindings"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.2"
TERMUX_PKG_SRCURL=https://github.com/vifm/vifm/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f0e06b50d756ab621a4b7494598a02c5911d422dc69e14f27017883672a72301
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses, file"

termux_step_pre_configure() {
	autoreconf -if
}

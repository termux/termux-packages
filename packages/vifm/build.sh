TERMUX_PKG_HOMEPAGE=https://vifm.info/
TERMUX_PKG_DESCRIPTION="File manager with vi like keybindings"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.12.1
TERMUX_PKG_SRCURL=https://github.com/vifm/vifm/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=410b2f183e9fdefb145cf6811c106e9297c9d8f7ddfe38f8840869c63e089f95
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses, file"

termux_step_pre_configure() {
	autoreconf -if
}

TERMUX_PKG_HOMEPAGE=https://vifm.info/
TERMUX_PKG_DESCRIPTION="File manager with vi like keybindings"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.5"
TERMUX_PKG_SRCURL="https://github.com/vifm/vifm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=2bb0b7ca2aa8be0d5df2a7271d4e50f27aec053652298c2b14be38703e206ab3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libmagic, ncurses"

termux_step_pre_configure() {
	autoreconf -if
}

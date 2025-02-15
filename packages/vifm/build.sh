TERMUX_PKG_HOMEPAGE=https://vifm.info/
TERMUX_PKG_DESCRIPTION="File manager with vi like keybindings"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.14
TERMUX_PKG_SRCURL=https://github.com/vifm/vifm/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c78d585327571f5572ecc5636571086d0247158d9ff56f2bd53f016cd0b2e3b5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses, file"

termux_step_pre_configure() {
	autoreconf -if
}

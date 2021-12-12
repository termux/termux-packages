TERMUX_PKG_HOMEPAGE=http://www.lxde.org/
TERMUX_PKG_DESCRIPTION="LXTask is a GUI application for the Lightweight X11 Desktop Environment (LXDE)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Yisus7u7"
TERMUX_PKG_VERSION=0.1.10
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/lxde/lxtask/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a3ea7f983396d816d8057eea8974e3cc12a870e658f71e15dec41c863e50f5d9
TERMUX_PKG_DEPENDS="gtk2, glib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./autogen.sh
}

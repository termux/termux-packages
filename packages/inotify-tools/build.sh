TERMUX_PKG_HOMEPAGE=https://github.com/rvoicilas/inotify-tools/wiki
TERMUX_PKG_DESCRIPTION="Programs providing a simple interface to inotify"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.22.6.0"
TERMUX_PKG_SRCURL=https://github.com/rvoicilas/inotify-tools/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c6b7e70f1df09e386217102a1fe041cfc15fa4f3d683d2970140b6814cf2ed12
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="inotify-tools-dev"
TERMUX_PKG_REPLACES="inotify-tools-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="-C libinotifytools"

termux_step_pre_configure() {
	./autogen.sh
}

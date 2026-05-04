TERMUX_PKG_HOMEPAGE=https://github.com/miurahr/pyppmd
TERMUX_PKG_DESCRIPTION="PPM compression/decompression library"
TERMUX_PKG_LICENSE="LGPL-2.1-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.1"
TERMUX_PKG_SRCURL="https://github.com/miurahr/pyppmd/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=ca5328cfff8be532fe834f1844c281b503f3b069e6ccb6232971eaf82474dbd3
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="build, installer"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag

termux_step_pre_configure() {
	rm CMakeLists.txt
}

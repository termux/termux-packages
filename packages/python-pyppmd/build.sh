TERMUX_PKG_HOMEPAGE=https://github.com/miurahr/pyppmd
TERMUX_PKG_DESCRIPTION="PPM compression/decompression library"
TERMUX_PKG_LICENSE="LGPL-2.1-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_SRCURL="https://github.com/miurahr/pyppmd/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=7da07545b5764d91011d5f8e9740fab6eb92265ab04990a7815a139ca4757443
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="build, installer"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	rm CMakeLists.txt
}

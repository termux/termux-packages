TERMUX_PKG_HOMEPAGE=https://yosyshq.net/yosys/
TERMUX_PKG_DESCRIPTION="A framework for RTL synthesis tools"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.27"
TERMUX_PKG_SRCURL=https://github.com/YosysHQ/yosys/archive/refs/tags/yosys-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bd6c933daf48c0929b4a9b3f75713d1f79c173be4bdb82fc5d2f5feb97f3668b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+"
TERMUX_PKG_DEPENDS="graphviz, libandroid-glob, libandroid-spawn, libc++, libffi, readline, tcl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -landroid-spawn"
}

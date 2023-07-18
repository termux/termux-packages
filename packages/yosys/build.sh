TERMUX_PKG_HOMEPAGE=https://yosyshq.net/yosys/
TERMUX_PKG_DESCRIPTION="A framework for RTL synthesis tools"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.31"
TERMUX_PKG_SRCURL=https://github.com/YosysHQ/yosys/archive/refs/tags/yosys-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=aadbd885b72a6c705035abcf7e2eb58d25689b18824ad91c71efd1d966f0bf50
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+"
TERMUX_PKG_DEPENDS="graphviz, libandroid-glob, libandroid-spawn, libc++, libffi, readline, tcl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -landroid-spawn"
}

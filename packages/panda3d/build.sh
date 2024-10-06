TERMUX_PKG_HOMEPAGE=https://www.panda3d.org/
TERMUX_PKG_DESCRIPTION="A framework for 3D rendering and game development for Python and C++ programs"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.10.14"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/panda3d/panda3d/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3ff568db545102f87d3e1191ba6a2f3cdc97ff2f62056973cf354743dd880591
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, python"
TERMUX_PKG_BUILD_DEPENDS="libandroid-glob"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
	CXXFLAGS+=" $CPPFLAGS"
	LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib/panda3d"
}

termux_step_make() {
	python makepanda/makepanda.py --nothing
}

termux_step_make_install() {
	python makepanda/installpanda.py --prefix $TERMUX_PREFIX
}

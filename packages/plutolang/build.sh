TERMUX_PKG_HOMEPAGE=https://plutolang.github.io/
TERMUX_PKG_DESCRIPTION="A superset of Lua 5.4, with unique features, optimizations, and improvements"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Komo @cattokomo"
TERMUX_PKG_VERSION="0.9.4"
TERMUX_PKG_SRCURL=https://github.com/PlutoLang/Pluto/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6a4fae052a9ad47e29a6767047c3e55ab5c887486d14e39248657ff43b45875c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++,readline"
TERMUX_PKG_BUILD_DEPENDS="readline"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
PLAT=linux
INSTALL_TOP=$TERMUX_PREFIX
INSTALL_INC=$TERMUX_PREFIX/include/pluto
"

termux_step_pre_configure() {
	CXXFLAGS+=" -std=c++17"
	export MYCFLAGS="-fPIC $CXXFLAGS $CPPFLAGS"
	export MYLDFLAGS="-fstack-protector-strong $LDFLAGS"
	export TERMUX_ARCH

	TERMUX_PKG_EXTRA_MAKE_ARGS+=" CXX=$(command -v $CXX)"
}

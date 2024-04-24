TERMUX_PKG_HOMEPAGE=https://plutolang.github.io/
TERMUX_PKG_DESCRIPTION="A superset of Lua 5.4, with unique features, optimizations, and improvements"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Komo @cattokomo"
TERMUX_PKG_VERSION="0.9.2"
TERMUX_PKG_SRCURL=https://github.com/PlutoLang/Pluto/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=26a111181838d8d735c16518e5f3dbc26a65a32ffed714e89b2453e33312e03d
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

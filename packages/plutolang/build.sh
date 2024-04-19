TERMUX_PKG_HOMEPAGE=https://plutolang.github.io/
TERMUX_PKG_DESCRIPTION="A superset of Lua 5.4, with unique features, optimizations, and improvements"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Komo @cattokomo"
TERMUX_PKG_VERSION="0.9.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/PlutoLang/Pluto/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1401cc2e25c9e8e23c9d30bd4ed83be48d48967a01f0cea3961ecaef4f97be8e
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

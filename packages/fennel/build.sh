TERMUX_PKG_HOMEPAGE="https://fennel-lang.org"
TERMUX_PKG_DESCRIPTION="A Lisp that compiles to Lua"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.1
TERMUX_PKG_SRCURL="https://github.com/bakpakin/Fennel/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=7456737a2e0fc17717ea2d80083cfcf04524abaa69b1eb79bded86b257398cd0
TERMUX_PKG_DEPENDS="lua53"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export LUA_VERSION=5.3
	export LUA=lua5.3
}

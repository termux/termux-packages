TERMUX_PKG_HOMEPAGE=https://luarocks.org/
TERMUX_PKG_DESCRIPTION="Deployment and management system for Lua modules"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=3.0.4
TERMUX_PKG_SRCURL=https://luarocks.org/releases/luarocks-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1236a307ca5c556c4fed9fdbd35a7e0e80ccf063024becc8c3bf212f37ff0edf
TERMUX_PKG_DEPENDS="curl, lua"
TERMUX_PKG_BUILD_DEPENDS="liblua-dev"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
TERMUX_PKG_EXTRA_MAKE_ARGS="LUA=/usr/bin/lua5.3"

termux_step_configure() {
	./configure --prefix=$TERMUX_PREFIX \
		--with-lua=$TERMUX_PREFIX \
		--lua-version=5.3
}

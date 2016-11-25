TERMUX_PKG_HOMEPAGE=https://luarocks.org/
TERMUX_PKG_DESCRIPTION="Deployment and management system for Lua modules"
TERMUX_PKG_VERSION=2.4.1
TERMUX_PKG_SRCURL=https://luarocks.org/releases/luarocks-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="curl, luajit"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure () {
	./configure --prefix=$TERMUX_PREFIX \
		--with-lua=$TERMUX_PREFIX \
		--lua-version=5.1
}

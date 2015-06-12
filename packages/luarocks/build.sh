TERMUX_PKG_HOMEPAGE=http://luarocks.org/
TERMUX_PKG_DESCRIPTION="Deployment and management system for Lua modules"
TERMUX_PKG_VERSION=2.2.1
TERMUX_PKG_SRCURL=http://luarocks.org/releases/luarocks-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="curl, luajit"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure () {
        ./configure --prefix=$TERMUX_PREFIX --with-lua=$TERMUX_PREFIX --with-lua-include=$TERMUX_PREFIX/include/luajit-2.0 --lua-version=5.1 --lua-suffix=jit
}

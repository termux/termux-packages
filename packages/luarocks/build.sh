TERMUX_PKG_HOMEPAGE=https://luarocks.org/
TERMUX_PKG_DESCRIPTION="Deployment and management system for Lua modules"
TERMUX_PKG_VERSION=2.4.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=3938df33de33752ff2c526e604410af3dceb4b7ff06a770bc4a240de80a1f934
TERMUX_PKG_SRCURL=https://luarocks.org/releases/luarocks-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="curl, lua"
TERMUX_PKG_BUILD_DEPENDS="liblua-dev"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_configure () {
	./configure --prefix=$TERMUX_PREFIX \
		--with-lua=$TERMUX_PREFIX \
		--lua-version=5.3
}

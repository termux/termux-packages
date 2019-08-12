TERMUX_PKG_HOMEPAGE=https://luarocks.org/
TERMUX_PKG_DESCRIPTION="Deployment and management system for Lua modules"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=3.1.3
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://luarocks.org/releases/luarocks-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c573435f495aac159e34eaa0a3847172a2298eb6295fcdc35d565f9f9b990513
TERMUX_PKG_DEPENDS="curl, lua"
TERMUX_PKG_BUILD_DEPENDS="liblua"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_EXTRA_MAKE_ARGS="LUA=/usr/bin/lua5.3"

termux_step_configure() {
	./configure --prefix=$TERMUX_PREFIX \
		--with-lua=$TERMUX_PREFIX \
		--with-lua-include=$TERMUX_PREFIX/include \
		--lua-version=5.3
}
termux_step_post_massage() {
	sed -i "1 s|$|lua|" bin/luarocks
	sed -i "1 s|$|lua|" bin/luarocks-admin
}

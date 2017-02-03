TERMUX_PKG_HOMEPAGE=https://luarocks.org/
TERMUX_PKG_DESCRIPTION="Deployment and management system for Lua modules"
TERMUX_PKG_VERSION=2.4.2
TERMUX_PKG_SRCURL=https://luarocks.org/releases/luarocks-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0e1ec34583e1b265e0fbafb64c8bd348705ad403fe85967fd05d3a659f74d2e5
TERMUX_PKG_DEPENDS="curl, lua"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_configure () {
	./configure --prefix=$TERMUX_PREFIX \
		--with-lua=$TERMUX_PREFIX \
		--lua-version=5.3
}

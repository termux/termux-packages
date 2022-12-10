TERMUX_PKG_HOMEPAGE=https://luarocks.org/
TERMUX_PKG_DESCRIPTION="Deployment and management system for Lua modules"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.9.2
TERMUX_PKG_SRCURL=https://luarocks.org/releases/luarocks-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bca6e4ecc02c203e070acdb5f586045d45c078896f6236eb46aa33ccd9b94edb
__LUA_VERSION=5.1 # Lua version against which it will be built.
# Do not use varible here since buildorder.py do not evaluate bash before reading.
TERMUX_PKG_DEPENDS="curl, lua51"
TERMUX_PKG_BUILD_DEPENDS="liblua51"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_configure() {
	if [ "$TERMUX_ON_DEVICE_BUILD" != true ]; then
		# Create temporary symlink to workaround luarock bootstrap
		# script trying to run cross-compiled lua
		mv "$TERMUX_PREFIX"/bin/lua"$__LUA_VERSION"{,.bak}
		ln -sf /usr/bin/lua"$__LUA_VERSION" "$TERMUX_PREFIX"/bin/lua"$__LUA_VERSION"
	fi

	./configure --prefix="$TERMUX_PREFIX" \
		--with-lua="$TERMUX_PREFIX"
}

termux_step_post_make_install() {
	if [ "$TERMUX_ON_DEVICE_BUILD" != "true" ]; then
		# Restore lua
		unlink "$TERMUX_PREFIX"/bin/lua"$__LUA_VERSION"
		mv "$TERMUX_PREFIX"/bin/lua"$__LUA_VERSION"{.bak,}
	fi
}

termux_step_post_massage() {
	if [ "$TERMUX_ON_DEVICE_BUILD" != true ]; then
		# Remove lua, due to us moving it back and fourth, the build system
		# thinks it is a newly compiled package.
		rm bin/lua"$__LUA_VERSION"
	fi
}

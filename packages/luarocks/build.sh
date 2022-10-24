TERMUX_PKG_HOMEPAGE=https://luarocks.org/
TERMUX_PKG_DESCRIPTION="Deployment and management system for Lua modules"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.9.1
TERMUX_PKG_SRCURL=https://luarocks.org/releases/luarocks-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ffafd83b1c42aa38042166a59ac3b618c838ce4e63f4ace9d961a5679ef58253
TERMUX_PKG_DEPENDS="curl, lua54"
TERMUX_PKG_BUILD_DEPENDS="liblua54"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_configure() {
	if $TERMUX_ON_DEVICE_BUILD; then
		TERMUX_PKG_EXTRA_MAKE_ARGS="LUA=$TERMUX_PREFIX/bin/lua5.4"
	else
		TERMUX_PKG_EXTRA_MAKE_ARGS="LUA=/usr/bin/lua5.4"
	fi

	./configure --prefix=$TERMUX_PREFIX \
		--with-lua=$TERMUX_PREFIX \
		--with-lua-include=$TERMUX_PREFIX/include/lua5.4 \
		--lua-version=5.4

	# Create temporary symlink to workaround luarock bootstrap
	# script trying to run cross-compiled lua
	mv $TERMUX_PREFIX/bin/lua5.4{,.bak}
	ln -sf /usr/bin/lua5.4 $TERMUX_PREFIX/bin/lua5.4
}

termux_step_post_make_install() {
	# Restore lua
	unlink $TERMUX_PREFIX/bin/lua5.4
	mv $TERMUX_PREFIX/bin/lua5.3{.bak,}
}

termux_step_post_massage() {
	sed -i "1 s|$|lua|" bin/luarocks
	sed -i "1 s|$|lua|" bin/luarocks-admin

	# Remove lua, due to us moving it back and fourth the package
	# thinks it is a newly compiled program
	rm bin/lua5.4
}

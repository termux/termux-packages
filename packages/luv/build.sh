TERMUX_PKG_HOMEPAGE=https://github.com/luvit/luv
TERMUX_PKG_DESCRIPTION="Bare libuv bindings for lua"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.50.0-1"
TERMUX_PKG_SRCURL=https://github.com/luvit/luv/releases/download/$TERMUX_PKG_VERSION/luv-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d867c3024d9c981d54f2edd83e13fd6dc1158f0608635f7b1c0f6b5586b5bc34
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libluajit, libuv"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_MODULE=OFF
-DBUILD_SHARED_LIBS=ON
-DLUA_BUILD_TYPE=System
-DLUAJIT_INCLUDE_DIR=$TERMUX_PREFIX/include/luajit-2.1
-DLUA_PACKAGE_DIR=$TERMUX_PREFIX/lib/lua/5.1
-DWITH_LUA_ENGINE=LuaJit
-DWITH_SHARED_LIBUV=ON
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=1

	local v=$(sed -En 's/^set\(LUV_VERSION_MAJOR\s+([0-9]+).*/\1/p' \
			CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	export LDFLAGS+=" -L$TERMUX_PREFIX/lib/lua/5.1"
}

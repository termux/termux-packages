TERMUX_PKG_HOMEPAGE=https://www.lua.org/
TERMUX_PKG_DESCRIPTION="Shared library for the Lua interpreter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=5.3.5
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=0c2eed3f960446e1a3e4b9a1ca2f3ff893b6ce41942cf54d5dd59ab4b3b058ac
TERMUX_PKG_SRCURL=https://www.lua.org/ftp/lua-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_MAKE_ARGS=linux
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_CONFLICTS=libluajit
TERMUX_PKG_REPLACES=libluajit
TERMUX_PKG_BUILD_DEPENDS="readline"

termux_step_pre_configure() {
	AR+=" rcu"
	CFLAGS+=" -fPIC -DLUA_COMPAT_5_2 -DLUA_COMPAT_UNPACK"
	export MYLDFLAGS=$LDFLAGS
}

termux_step_post_make_install() {
	# Add a pkg-config file for the system zlib
	cat > "$PKG_CONFIG_LIBDIR/lua.pc" <<-HERE
		Name: Lua
		Description: An Extensible Extension Language
		Version: $TERMUX_PKG_VERSION
		Requires:
		Libs: -llua -lm
	HERE
}

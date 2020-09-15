TERMUX_PKG_HOMEPAGE=https://www.lua.org/
TERMUX_PKG_DESCRIPTION="Shared library for the Lua interpreter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=5.4.0
TERMUX_PKG_SRCURL=https://www.lua.org/ftp/lua-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=eac0836eb7219e421a96b7ee3692b93f0629e4cdb0c788432e3d10ce9ed47e28
TERMUX_PKG_EXTRA_MAKE_ARGS=linux
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BREAKS="liblua-dev"
TERMUX_PKG_REPLACES="liblua-dev"
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

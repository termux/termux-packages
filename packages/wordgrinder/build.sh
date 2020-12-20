TERMUX_PKG_HOMEPAGE=http://cowlark.com/wordgrinder/
TERMUX_PKG_DESCRIPTION="A Unicode-aware character cell word processor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="licenses/COPYING.Lua, licenses/COPYING.LuaBitOp, licenses/COPYING.LuaFileSystem, licenses/COPYING.Minizip, licenses/COPYING.Scowl, licenses/COPYING.uthash, licenses/COPYING.wcwidth, licenses/COPYING.WordGrinder, licenses/COPYING.xpattern"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8
TERMUX_PKG_SRCURL=https://github.com/davidgiven/wordgrinder/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=856cbed2b4ccd5127f61c4997a30e642d414247970f69932f25b4b5a81b18d3f
TERMUX_PKG_DEPENDS="liblua53, ncurses, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_ninja

	# Missing and causes install failure.
	touch licenses/COPYING.LuaFileSystem

	make CC=gcc OBJDIR="$PWD/build" "$PWD"/build/lua
	make OBJDIR="$PWD/build" LUA_PACKAGE=lua53
}

termux_step_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR"/bin/wordgrinder-lua53-curses-release \
		"$TERMUX_PREFIX"/bin/wordgrinder
	install -Dm600 \
		"$TERMUX_PKG_SRCDIR"/bin/wordgrinder.1 \
		"$TERMUX_PREFIX"/share/man/man1/
}

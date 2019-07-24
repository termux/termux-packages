TERMUX_PKG_HOMEPAGE=http://cowlark.com/wordgrinder/
TERMUX_PKG_DESCRIPTION="A Unicode-aware character cell word processor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.7.2
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://github.com/davidgiven/wordgrinder/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=4e1bc659403f98479fe8619655f901c8c03eb87743374548b4d20a41d31d1dff
TERMUX_PKG_DEPENDS="liblua, ncurses, zlib"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make() {
	termux_setup_ninja
	make CC=gcc OBJDIR="$PWD/build" "$PWD"/build/lua
	make OBJDIR="$PWD/build" LUA_PACKAGE=lua
}

termux_step_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR"/bin/wordgrinder-lua-curses-release \
		"$TERMUX_PREFIX"/bin/wordgrinder
	install -Dm600 \
		"$TERMUX_PKG_SRCDIR"/bin/wordgrinder.1 \
		"$TERMUX_PREFIX"/share/man/man1/
}

TERMUX_PKG_HOMEPAGE=http://cowlark.com/wordgrinder/
TERMUX_PKG_DESCRIPTION="a Unicode-aware character cell word processor"
TERMUX_PKG_VERSION=0.7.1
TERMUX_PKG_SRCURL=https://github.com/davidgiven/wordgrinder/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=54085af7963e1f67342bc0b1b20d1ccc75494f2e23d401b601cf3089acea747c
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, liblua"
termux_step_make() {
	termux_setup_ninja
	make CC=gcc OBJDIR=$PWD/build $PWD/build/lua

	make OBJDIR=$PWD/build LUA_PACKAGE=lua || sleep 2
	
}
termux_step_make_install() {
	cp bin/*release $TERMUX_PREFIX/bin/wordgrinder
	cp bin/wordgrinder.1 $TERMUX_PREFIX/share/man/man1/
}

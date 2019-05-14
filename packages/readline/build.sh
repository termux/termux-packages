TERMUX_PKG_HOMEPAGE="https://tiswww.case.edu/php/chet/readline/rltop.html"
TERMUX_PKG_DESCRIPTION="Library that allow users to edit command lines as they are typed in"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_BREAKS="bash (<< 5.0)"
TERMUX_PKG_VERSION="8.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=e339f51971478d369f8a053a330a190781acb9864cf4c541060f12078948e461
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/readline/readline-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-curses --enable-multibyte bash_cv_wcwidth_broken=no"
TERMUX_PKG_EXTRA_MAKE_ARGS="SHLIB_LIBS=-lncursesw"
TERMUX_PKG_CONFFILES="etc/inputrc"

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/lib/pkgconfig
	cp readline.pc $TERMUX_PREFIX/lib/pkgconfig/

	mkdir -p $TERMUX_PREFIX/etc
	cp $TERMUX_PKG_BUILDER_DIR/inputrc $TERMUX_PREFIX/etc/
}

TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/gnushogi/
TERMUX_PKG_DESCRIPTION="Program that plays the game of Shogi, also known as Japanese Chess"
TERMUX_PKG_VERSION=1.4.2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gnushogi/gnushogi-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_curses_clrtoeol=yes --with-curses"
TERMUX_PKG_RM_AFTER_INSTALL="info/gnushogi.info"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_HOSTBUILD=yes

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
}

termux_step_post_configure () {
	cp $TERMUX_PKG_HOSTBUILD_DIR/gnushogi/pat2inc $TERMUX_PKG_BUILDDIR/gnushogi/pat2inc
	# Update timestamps so that the binaries does not get rebuilt:
	$TERMUX_TOUCH -d "next hour" $TERMUX_PKG_BUILDDIR/gnushogi/pat2inc
}

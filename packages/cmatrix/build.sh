TERMUX_PKG_HOMEPAGE=http://www.asty.org/cmatrix/
TERMUX_PKG_DESCRIPTION="Command producing a Matrix-style animation"
TERMUX_PKG_VERSION=1.2a
TERMUX_PKG_SRCURL=http://www.asty.org/cmatrix/dist/cmatrix-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=$TERMUX_PREFIX/share/man"
TERMUX_PKG_DEPENDS="ncurses"

termux_step_pre_configure () {
	export ac_cv_file__usr_lib_kbd_consolefonts=no
	export ac_cv_file__usr_share_consolefonts=no
	export ac_cv_file__usr_lib_X11_fonts_misc=no
	export ac_cv_file__usr_X11R6_lib_X11_fonts_misc=no

	# Fix old configure script broken by configure args:
	cd $TERMUX_PKG_SRCDIR && autoconf
}

TERMUX_PKG_HOMEPAGE=http://www.asty.org/cmatrix/
TERMUX_PKG_DESCRIPTION="Command producing a Matrix-style animation"
TERMUX_PKG_VERSION=1.2a
TERMUX_PKG_SRCURL=http://www.asty.org/cmatrix/dist/cmatrix-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1fa6e6caea254b6fe70a492efddc1b40ad7ccb950a5adfd80df75b640577064c
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=$TERMUX_PREFIX/share/man"
TERMUX_PKG_DEPENDS="ncurses"

termux_step_pre_configure () {
	export ac_cv_file__usr_lib_kbd_consolefonts=no
	export ac_cv_file__usr_share_consolefonts=no
	export ac_cv_file__usr_lib_X11_fonts_misc=no
	export ac_cv_file__usr_X11R6_lib_X11_fonts_misc=no
}

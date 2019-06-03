TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gtypist/
TERMUX_PKG_DESCRIPTION="Universal typing tutor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.9.5
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gtypist/gtypist-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c13af40b12479f8219ffa6c66020618c0ce305ad305590fde02d2c20eb9cf977
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_header_ncursesw_ncurses_h=yes --enable-nls=no ac_cv_header_libintl_h=no"
TERMUX_PKG_RM_AFTER_INSTALL="share/emacs/site-lisp bin/typefortune share/man/man1/typefortune.1"

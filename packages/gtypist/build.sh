TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/gtypist/
TERMUX_PKG_DESCRIPTION="Universal typing tutor"
TERMUX_PKG_VERSION=2.9.5
TERMUX_PKG_SRCURL=http://ftp.gnu.org/gnu/gtypist/gtypist-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_header_ncursesw_ncurses_h=yes ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes --enable-nls=no ac_cv_header_libintl_h=no"
TERMUX_PKG_RM_AFTER_INSTALL="share/emacs/site-lisp bin/typefortune share/man/man1/typefortune.1"

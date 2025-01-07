TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gtypist/
TERMUX_PKG_DESCRIPTION="Universal typing tutor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.10"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gtypist/gtypist-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f1e79cd95742c84c6d035f6d8f393a2a1be0e00b1c016a22462df16d6667562c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_header_ncursesw_ncurses_h=yes --enable-nls=no ac_cv_header_libintl_h=no"
TERMUX_PKG_RM_AFTER_INSTALL="share/emacs/site-lisp bin/typefortune share/man/man1/typefortune.1"

TERMUX_PKG_HOMEPAGE=https://cgdb.github.io/
TERMUX_PKG_DESCRIPTION="A lightweight curses (terminal-based) interface to the GNU Debugger (GDB)"
TERMUX_PKG_DEPENDS="ncurses,readline"
TERMUX_PKG_VERSION=0.6.8
TERMUX_PKG_SRCURL=https://cgdb.me/files/cgdb-0.6.8.tar.gz
TERMUX_PKG_SHA256=be203e29be295097439ab67efe3dc8261f742c55ff3647718d67d52891f4cf41
TERMUX_PKG_FOLDERNAME=cgdb-${TERMUX_PKG_VERSION}
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_ncursesw6_addnwstr=yes ac_cv_file__dev_ptmx=yes ac_cv_func_setpgrp_void=true ac_cv_rl_version=7"
TERMUX_PKG_RM_AFTER_INSTALL="share/applications share/pixmaps"

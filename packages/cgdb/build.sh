TERMUX_PKG_HOMEPAGE=https://cgdb.github.io/
TERMUX_PKG_DESCRIPTION="A lightweight curses (terminal-based) interface to the GNU Debugger (GDB)"
TERMUX_PKG_DEPENDS="ncurses,readline,gdb,libutil"
TERMUX_PKG_VERSION=0.7.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://cgdb.me/files/cgdb-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bf7a9264668db3f9342591b08b2cc3bbb08e235ba2372877b4650b70c6fb5423
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_ncursesw6_addnwstr=yes ac_cv_file__dev_ptmx=yes
ac_cv_func_setpgrp_void=true ac_cv_rl_version=7
ac_cv_file__proc_self_status=yes
"
TERMUX_PKG_RM_AFTER_INSTALL="share/applications share/pixmaps"

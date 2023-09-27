TERMUX_PKG_HOMEPAGE=https://cgdb.github.io/
TERMUX_PKG_DESCRIPTION="A lightweight curses (terminal-based) interface to the GNU Debugger (GDB)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.0
TERMUX_PKG_SRCURL=https://cgdb.me/files/cgdb-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0d38b524d377257b106bad6d856d8ae3304140e1ee24085343e6ddf1b65811f1
TERMUX_PKG_DEPENDS="libc++, ncurses, readline, gdb"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_ncursesw6_addnwstr=yes ac_cv_file__dev_ptmx=yes
ac_cv_func_setpgrp_void=true ac_cv_rl_version=7
ac_cv_file__proc_self_status=yes
"
TERMUX_PKG_RM_AFTER_INSTALL="share/applications share/pixmaps"

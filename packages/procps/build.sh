TERMUX_PKG_HOMEPAGE=https://packages.debian.org/sid/procps
TERMUX_PKG_DESCRIPTION="Utilities that give information about processes using the /proc filesystem"
TERMUX_PKG_VERSION=3.3.10
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/procps-ng/Production/procps-ng-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_FOLDERNAME=procps-ng-${TERMUX_PKG_VERSION}
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_search_dlopen= --enable-sigwinch"
TERMUX_PKG_DEPENDS="ncurses"
# https://bugs.launchpad.net/ubuntu/+source/coreutils/+bug/141168:
# "For compatibility between distributions, can we have /bin/kill made available from coreutils?"
TERMUX_PKG_RM_AFTER_INSTALL="bin/kill share/man/man1/kill.1 usr/bin/w share/man/man1/w.1 usr/bin/slabtop share/man/man1/slabtop.1"

CPPFLAGS+=" -Ddirect=dirent"

termux_step_post_massage () {
        mv usr/bin/* bin/
}

TERMUX_PKG_HOMEPAGE=http://www.brain-dump.org/projects/dvtm/
TERMUX_PKG_DESCRIPTION="Terminal tiling window manager"
TERMUX_PKG_VERSION=0.15
TERMUX_PKG_SRCURL=http://www.brain-dump.org/projects/dvtm/dvtm-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="libutil, ncurses"

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
}

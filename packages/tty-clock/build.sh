TERMUX_PKG_HOMEPAGE=https://github.com/xorg62/tty-clock
TERMUX_PKG_DESCRIPTION="tty-clock is a simple ncurses-based clock that shows the time and date using a large display. It has a few commandline options to customize the output."
TERMUX_PKG_VERSION=0.1.20160928
# The current tagged release is a few years older than the latest commit and has many problems
_COMMIT=516afbf9f96101c0bed1c366f80d7ca087b0557d
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=https://github.com/xorg62/tty-clock/archive/${_COMMIT}.tar.gz
TERMUX_PKG_FOLDERNAME=tty-clock-${_COMMIT}
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_make () {
	LDFLAGS+=" -lncurses"
	CFLAGS+=" $CPPFLAGS"
}


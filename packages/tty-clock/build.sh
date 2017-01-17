TERMUX_PKG_DESCRIPTION="tty-clock is a simple ncurses-based clock that shows the time and date using a large display. It has a few commandline options to customize the output."
TERMUX_PKG_VERSION=2.3
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=https://github.com/xorg62/tty-clock/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=tty-clock-${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_configure() {
    LDFLAGS+=" -lncurses"
    CFLAGS+=" $CPPFLAGS"
}


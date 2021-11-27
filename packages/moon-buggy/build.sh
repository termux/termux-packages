TERMUX_PKG_HOMEPAGE=https://github.com/seehuhn/moon-buggy
TERMUX_PKG_DESCRIPTION="Simple game where you drive a car across the moon's surface"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_VERSION=1.0.51
TERMUX_PKG_REVISION=4
# Main site down 2017-01-06.
# TERMUX_PKG_SRCURL=http://m.seehuhn.de/programs/moon-buggy-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SRCURL=ftp://ftp.netbsd.org/pub/pkgsrc/distfiles/moon-buggy-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=352dc16ccae4c66f1e87ab071e6a4ebeb94ff4e4f744ce1b12a769d02fe5d23f
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--sharedstatedir=$TERMUX_PREFIX/var"

termux_step_make_install () {
	mkdir -p $TERMUX_PREFIX/share/man/man6
	cp moon-buggy $TERMUX_PREFIX/bin
	cp moon-buggy.6 $TERMUX_PREFIX/share/man/man6
}

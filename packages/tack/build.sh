TERMUX_PKG_HOMEPAGE=http://invisible-island.net/ncurses/tack.html
TERMUX_PKG_DESCRIPTION="Program that can be used to verify or refine a terminfo (terminal information) description of a terminal"
TERMUX_PKG_VERSION=1.07
# Note: tack does not use a version number in the tar filename, so it's not possible
# to link to other than the latest release.
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_SRCURL=http://invisible-island.net/datafiles/release/tack.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ncursesw --mandir=$TERMUX_PREFIX/share/man"
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_FOLDERNAME=tack-${TERMUX_PKG_VERSION}

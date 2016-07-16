TERMUX_PKG_HOMEPAGE=http://hte.sourceforge.net/
TERMUX_PKG_DESCRIPTION="File editor/viewer/analyzer for executables"
TERMUX_PKG_VERSION=2.1.0
TERMUX_PKG_SRCURL=http://heanet.dl.sourceforge.net/project/hte/ht-source/ht-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="ncurses"

termux_step_post_configure () {
	mkdir -p $TERMUX_PKG_BUILDDIR/tools/
	g++ -Os $TERMUX_PKG_SRCDIR/tools/bin2c.c -o $TERMUX_PKG_BUILDDIR/tools/bin2c
	# Update timestamps so that the binary does not get rebuilt:
	$TERMUX_TOUCH -d "next hour" $TERMUX_PKG_BUILDDIR/tools/bin2c
}

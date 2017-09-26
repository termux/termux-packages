TERMUX_PKG_HOMEPAGE=http://hte.sourceforge.net/
TERMUX_PKG_DESCRIPTION="File editor/viewer/analyzer for executables"
TERMUX_PKG_VERSION=2.1.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/hte/ht-source/ht-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=31f5e8e2ca7f85d40bb18ef518bf1a105a6f602918a0755bc649f3f407b75d70
TERMUX_PKG_DEPENDS="ncurses, liblzo"

termux_step_post_configure () {
	mkdir -p $TERMUX_PKG_BUILDDIR/tools/
	g++ -Os $TERMUX_PKG_SRCDIR/tools/bin2c.c -o $TERMUX_PKG_BUILDDIR/tools/bin2c
	# Update timestamps so that the binary does not get rebuilt:
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/tools/bin2c
}

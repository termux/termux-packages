TERMUX_PKG_HOMEPAGE=http://www.greenwoodsoftware.com/less/
TERMUX_PKG_DESCRIPTION="Terminal pager program used to view the contents of a text file one screen at a time"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_VERSION=479
TERMUX_PKG_SRCURL=http://www.greenwoodsoftware.com/less/less-${TERMUX_PKG_VERSION}.tar.gz

termux_step_pre_configure () {
	# Mistake in packaging less 478
	chmod +x $TERMUX_PKG_SRCDIR/configure
}

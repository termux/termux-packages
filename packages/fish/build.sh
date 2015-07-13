TERMUX_PKG_HOMEPAGE=http://fishshell.com/
TERMUX_PKG_DESCRIPTION="Shell geared towards interactive use"
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_SRCURL=http://fishshell.com/files/${TERMUX_PKG_VERSION}/fish-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure () {
	cd $TERMUX_PKG_SRCDIR
	autoconf
}

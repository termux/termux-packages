TERMUX_PKG_HOMEPAGE=http://ninvaders.sourceforge.net
TERMUX_PKG_DESCRIPTION="Space Invaders clone based on ncurses for ASCII output"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.1.1
TERMUX_PKG_SRCURL=https://netix.dl.sourceforge.net/project/ninvaders/ninvaders/${TERMUX_PKG_VERSION}/ninvaders-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bfbc5c378704d9cf5e7fed288dac88859149bee5ed0850175759d310b61fd30b
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make_install() {
	install -Dm700 nInvaders $TERMUX_PREFIX/bin/
}

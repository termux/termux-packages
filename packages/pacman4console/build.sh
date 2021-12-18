TERMUX_PKG_HOMEPAGE=https://sites.google.com/site/doctormike/pacman.html
TERMUX_PKG_DESCRIPTION="A 9 level ncurses pacman game with editor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://ftp.debian.org/debian/pool/main/p/pacman4console/pacman4console_${TERMUX_PKG_VERSION}.orig.tar.gz
TERMUX_PKG_SHA256=9a5c4a96395ce4a3b26a9896343a2cdf488182da1b96374a13bf5d811679eb90
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GROUPS="games"

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX"/share/man/man1 "$TERMUX_PREFIX"/share/man/man6
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/pacmanedit.1 "$TERMUX_PREFIX"/share/man/man1/
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/pacman.6 "$TERMUX_PREFIX"/share/man/man6/
}

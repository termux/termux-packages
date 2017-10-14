TERMUX_PKG_HOMEPAGE=http://rephial.org/
TERMUX_PKG_DESCRIPTION="Dungeon exploration adventure game"
TERMUX_PKG_VERSION=4.1.0
TERMUX_PKG_SHA256=3d143e490e1e56aa96ac0b3cc88b71be30f2fe16ef0a70bd508c4353f3fa1b6e
TERMUX_PKG_SRCURL=http://rephial.org/downloads/4.1/angband-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-x11 --bindir=$TERMUX_PREFIX/bin --sysconfdir=$TERMUX_PREFIX/share/angband"
TERMUX_PKG_RM_AFTER_INSTALL="share/angband/xtra share/angband/icons"

termux_step_pre_configure () {
	./autogen.sh
	perl -p -i -e 's|ncursesw5-config|ncursesw6-config|g' configure
}

termux_step_post_make_install () {
	rm -Rf $TERMUX_PREFIX/share/angband/{fonts,sounds}
}

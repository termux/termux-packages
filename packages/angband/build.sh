TERMUX_PKG_HOMEPAGE=http://rephial.org/
TERMUX_PKG_DESCRIPTION="Dungeon exploration adventure game"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=4.2.1
TERMUX_PKG_SHA256=acd735c9d46bf86ee14337c71c56f743ad13ec2a95d62e7115604621e7560d0f
TERMUX_PKG_SRCURL=http://rephial.org/downloads/${TERMUX_PKG_VERSION:0:3}/angband-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-x11 --bindir=$TERMUX_PREFIX/bin --sysconfdir=$TERMUX_PREFIX/share/angband"
TERMUX_PKG_RM_AFTER_INSTALL="share/angband/xtra share/angband/icons"

termux_step_pre_configure () {
	./autogen.sh
	perl -p -i -e 's|ncursesw5-config|ncursesw6-config|g' configure
}

termux_step_post_make_install () {
	rm -Rf $TERMUX_PREFIX/share/angband/{fonts,sounds}
}

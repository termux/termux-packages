TERMUX_PKG_VERSION=4.0.1
TERMUX_PKG_SRCURL=http://rephial.org/downloads/4.0/angband-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_HOMEPAGE=http://rephial.org/
TERMUX_PKG_DESCRIPTION="Dungeon exploration game where you play an adventurer seeking riches, fighting monsters and preparing for a final battle with Morgoth, the Lord of Darkness"
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-x --bindir=$TERMUX_PREFIX/bin --sysconfdir=$TERMUX_PREFIX/share/angband"
TERMUX_PKG_RM_AFTER_INSTALL="share/angband/xtra"

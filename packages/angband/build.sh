TERMUX_PKG_HOMEPAGE=http://rephial.org/
TERMUX_PKG_DESCRIPTION="Dungeon exploration adventure game"
TERMUX_PKG_VERSION=4.1.0
TERMUX_PKG_SRCURL=http://rephial.org/downloads/4.1/angband-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ea52266e52b66d6bf2ab3728b3bc6c7c3875130973430021e31bf56000c0df8b
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-x11 --bindir=$TERMUX_PREFIX/bin --sysconfdir=$TERMUX_PREFIX/share/angband"
TERMUX_PKG_RM_AFTER_INSTALL="share/angband/xtra share/angband/icons"
TERMUX_PKG_FOLDERNAME=angband-master

termux_step_pre_configure () {
	./autogen.sh
	perl -p -i -e 's|ncursesw5-config|ncursesw6-config|g' configure
}

termux_step_post_make_install () {
	rm -Rf $TERMUX_PREFIX/share/angband/{fonts,sounds}
}

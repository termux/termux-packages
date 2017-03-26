TERMUX_PKG_HOMEPAGE=http://rephial.org/
TERMUX_PKG_DESCRIPTION="Dungeon exploration adventure game"
TERMUX_PKG_VERSION=4.0.5
TERMUX_PKG_SRCURL=http://rephial.org/downloads/4.0/angband-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0d769a0f349842b0c78cbcd1804a9e08f064e75ca26b957710e4c2a3eb14f852
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
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

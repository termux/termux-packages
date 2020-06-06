TERMUX_PKG_HOMEPAGE=https://umoria.org
TERMUX_PKG_DESCRIPTION="Rogue-like game with an infinite dungeon"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=5.7.12
TERMUX_PKG_SRCURL=https://github.com/dungeons-of-moria/umoria/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7be03361ac21a850e7be8f1a53e3ab68bd57637543ccb1296eb40d9d4a7b32a6
TERMUX_PKG_DEPENDS="libc++, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dbuild_dir=$TERMUX_PKG_BUILDDIR"

termux_step_create_debscripts() {
    # Create scores file in a debscript, so an update to the package wouldn't erease any scores
    echo "mkdir -p $TERMUX_PREFIX/var/games/moria/" > postinst
    echo "touch $TERMUX_PREFIX/var/games/moria/scores" >> postinst
    chmod 0755 postinst
}

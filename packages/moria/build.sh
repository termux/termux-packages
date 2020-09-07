TERMUX_PKG_HOMEPAGE=https://umoria.org
TERMUX_PKG_DESCRIPTION="Rogue-like game with an infinite dungeon"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=5.7.13
TERMUX_PKG_SRCURL=https://github.com/dungeons-of-moria/umoria/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a9dae819aca650ea2cd0a5d05853d768f815617ff61de87962325231758f62b9
TERMUX_PKG_DEPENDS="libc++, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dbuild_dir=$TERMUX_PKG_BUILDDIR"

termux_step_create_debscripts() {
    # Create scores file in a debscript, so an update to the package wouldn't erease any scores
    echo "mkdir -p $TERMUX_PREFIX/var/games/moria/" > postinst
    echo "touch $TERMUX_PREFIX/var/games/moria/scores" >> postinst
    chmod 0755 postinst
}

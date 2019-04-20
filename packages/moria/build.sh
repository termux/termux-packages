TERMUX_PKG_HOMEPAGE=https://umoria.org
TERMUX_PKG_DESCRIPTION="Rogue-like game with an infinite dungeon"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=5.7.10
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=https://github.com/dungeons-of-moria/umoria/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a43b695d42692245208e9fca4c89976c24947ea7931caa80f79e7f051305b512
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dbuild_dir=$TERMUX_PKG_BUILDDIR"

termux_step_create_debscripts() {
    # Create scores file in a debscript, so an update to the package wouldn't erease any scores
    echo "mkdir -p $TERMUX_PREFIX/var/games/moria/" > postinst
    echo "touch $TERMUX_PREFIX/var/games/moria/scores" >> postinst
    chmod 0755 postinst
}

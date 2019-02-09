TERMUX_PKG_HOMEPAGE=http://remarque.org/~grabiner/moria.html
TERMUX_PKG_DESCRIPTION="Rogue-like game with an infinite dungeon"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=5.6
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
# This seems to be a pretty good mirror
TERMUX_PKG_SRCURL=https://github.com/HunterZ/umoria/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1ee52ec001539945139b2960e8441f490d2b7f5fe6dce5a070686a178515d182
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
    ln -s $TERMUX_PKG_SRCDIR/source/* $TERMUX_PKG_SRCDIR/
    ln -s $TERMUX_PKG_SRCDIR/unix/* $TERMUX_PKG_SRCDIR/
    mkdir -p $TERMUX_PREFIX/share/man/man6/
    cp $TERMUX_PKG_SRCDIR/doc/moria.man $TERMUX_PREFIX/share/man/man6/moria.6
}
termux_step_create_debscripts() {
    # Create scores file in a debscript, so an update to the package wouldn't erease any scores
    echo "mkdir -p $TERMUX_PREFIX/var/games/moria/" > postinst
    echo "touch $TERMUX_PREFIX/var/games/moria/scores" >> postinst
    chmod 0755 postinst

}

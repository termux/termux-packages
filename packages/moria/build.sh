TERMUX_PKG_HOMEPAGE=https://umoria.org
TERMUX_PKG_DESCRIPTION="Rogue-like game with an infinite dungeon"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.7.14
TERMUX_PKG_SRCURL=https://github.com/dungeons-of-moria/umoria/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6c5cfd470ba15b2a93606bfa7b655683ace9e55dc783053346849881fdb17f2c
TERMUX_PKG_DEPENDS="libc++, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dbuild_dir=$TERMUX_PKG_BUILDDIR"

termux_step_create_debscripts() {
    # Create scores file in a debscript, so an update to the package wouldn't erease any scores
    echo "mkdir -p $TERMUX_PREFIX/lib/games/moria/" > postinst
    echo "touch $TERMUX_PREFIX/lib/games/moria/scores.dat" >> postinst
    chmod 0755 postinst
}

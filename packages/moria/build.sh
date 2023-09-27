TERMUX_PKG_HOMEPAGE=https://umoria.org
TERMUX_PKG_DESCRIPTION="Rogue-like game with an infinite dungeon"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.7.15
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/dungeons-of-moria/umoria/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=97f76a68b856dd5df37c20fc57c8a51017147f489e8ee8866e1764778b2e2d57
TERMUX_PKG_DEPENDS="libc++, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dbuild_dir=$TERMUX_PKG_BUILDDIR"
TERMUX_PKG_GROUPS="games"

termux_step_create_debscripts() {
	# Create scores file in a debscript, so an update to the package wouldn't erase any scores
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "DIR=$TERMUX_PREFIX/lib/games/moria" >> postinst
	echo "mkdir -p \$DIR" >> postinst
	echo "touch \$DIR/scores.dat" >> postinst
	chmod 0755 postinst

	# https://github.com/termux/termux-packages/issues/1401
	echo "#!$TERMUX_PREFIX/bin/sh" > prerm
	echo "cd $TERMUX_PREFIX/lib/games/moria || exit" >> prerm
	echo "case \$1 in" >> prerm
	echo "purge|remove)" >> prerm
	echo "rm -f game.sav scores.dat" >> prerm
	echo "esac" >> prerm
	chmod 0755 prerm
}

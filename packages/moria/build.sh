TERMUX_PKG_HOMEPAGE=https://umoria.org
TERMUX_PKG_DESCRIPTION="Rogue-like game with an infinite dungeon"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.7.15
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://github.com/dungeons-of-moria/umoria/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=97f76a68b856dd5df37c20fc57c8a51017147f489e8ee8866e1764778b2e2d57
TERMUX_PKG_DEPENDS="libc++, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dbuild_dir=$TERMUX_PKG_BUILDDIR"
TERMUX_PKG_GROUPS="games"

termux_step_create_debscripts() {
	# Create scores file in a debscript, so an update to the package wouldn't erase any scores
	cat <<-EOF > ./postinst
		#!$TERMUX_PREFIX/bin/sh
		DIR=$TERMUX_PREFIX/lib/games/moria
		mkdir -p \$DIR
		touch \$DIR/scores.dat
	EOF

	# https://github.com/termux/termux-packages/issues/1401
	cat <<-EOF > ./prerm
		#!$TERMUX_PREFIX/bin/sh
		cd $TERMUX_PREFIX/lib/games/moria || exit
		case \$1 in
			purge|remove)
			rm -f game.sav scores.dat;;
		esac
	EOF
}

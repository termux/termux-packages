TERMUX_PKG_HOMEPAGE=https://www.polyomino.org.uk/computer/software/bsd-games/
TERMUX_PKG_DESCRIPTION="Classic text mode games from UNIX folklore"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE, adventure/LICENSE, atc/LICENSE, battlestar/LICENSE, caesar/LICENSE, dab/LICENSE, drop4/LICENSE, gofish/LICENSE, gomoku/LICENSE, hangman/LICENSE, robots/LICENSE, sail/LICENSE, snake/LICENSE, spirhunt/LICENSE, worm/LICENSE, wump/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:3.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/bsd-games/bsd-games-${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=78bfdf7f4e1f61ed42ad1209ef52520b89a583bd511e9606b8162f813078048d
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GROUPS="games"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--localstatedir=$TERMUX_PREFIX/games"

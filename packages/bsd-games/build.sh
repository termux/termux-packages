TERMUX_PKG_HOMEPAGE=https://www.polyomino.org.uk/computer/software/bsd-games/
TERMUX_PKG_DESCRIPTION="Classic text mode games from UNIX folklore"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE, adventure/LICENSE, atc/LICENSE, battlestar/LICENSE, caesar/LICENSE, dab/LICENSE, drop4/LICENSE, gofish/LICENSE, gomoku/LICENSE, hangman/LICENSE, robots/LICENSE, sail/LICENSE, snake/LICENSE, spirhunt/LICENSE, worm/LICENSE, wump/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:3.2
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/msharov/bsd-games/archive/refs/tags/v${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=41a3aecbf35afff4ba1ff2af9dab7dc25dddf5e722ece6ea58b992e6bd53386e
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GROUPS="games"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--localstatedir=$TERMUX_PREFIX/games"

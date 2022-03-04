TERMUX_PKG_HOMEPAGE=https://www.polyomino.org.uk/computer/software/bsd-games/
TERMUX_PKG_DESCRIPTION="Classic text mode games from UNIX folklore"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE, adventure/LICENSE, atc/LICENSE, battlestar/LICENSE, caesar/LICENSE, dab/LICENSE, drop4/LICENSE, gofish/LICENSE, gomoku/LICENSE, hangman/LICENSE, robots/LICENSE, sail/LICENSE, snake/LICENSE, spirhunt/LICENSE, worm/LICENSE, wump/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=511ca9eb1fe71d3ab1948c0e3b61336150ff389e
TERMUX_PKG_VERSION=2021.11.15
TERMUX_PKG_SRCURL=https://github.com/msharov/bsd-games.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GROUPS="games"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi
}

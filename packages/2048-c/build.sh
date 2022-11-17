TERMUX_PKG_HOMEPAGE=https://github.com/mevdschee/2048.c
TERMUX_PKG_DESCRIPTION="Console version of the game '2048' for GNU/Linux"
TERMUX_PKG_LICENSE="MIT"
_COMMIT=6c04517bb59c28f3831585da338f021bc2ea86d6
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2022.10.23
TERMUX_PKG_SRCURL=https://github.com/mevdschee/2048.c.git
TERMUX_PKG_GIT_BRANCH=main
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

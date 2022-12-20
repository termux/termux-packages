TERMUX_PKG_HOMEPAGE="https://github.com/Canop/mazter"
TERMUX_PKG_DESCRIPTION="Mazes in your terminal"
TERMUX_PKG_GROUPS="games"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=a02de683f93a61690d1a4f3b845f654f5e026484
TERMUX_PKG_VERSION=2022.08.13
TERMUX_PKG_SRCURL="https://github.com/Canop/mazter.git"
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_BUILD_IN_SRC=true

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

TERMUX_PKG_HOMEPAGE="https://github.com/ceu-lang/ceu"
TERMUX_PKG_DESCRIPTION="The Structured Synchronous Reactive Programming Language Céu"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL="https://github.com/ceu-lang/ceu.git"
TERMUX_PKG_GIT_BRANCH="master"
_COMMIT="5e0c8d3004ad98658ffe82823ad8303a8d371064"
TERMUX_PKG_VERSION="2019.07.17"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BUILD_DEPENDS="lua53, lua-lpeg"
TERMUX_PKG_DEPENDS="lua53, lua-lpeg, liblua53"

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

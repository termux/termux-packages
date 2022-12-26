TERMUX_PKG_HOMEPAGE=http://wiz-lang.org/
TERMUX_PKG_DESCRIPTION="A high-level assembly language for writing homebrew software for retro console platforms"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=a174205e1694ab225c11813d3a3ab9e81742869d
TERMUX_PKG_VERSION=2022.06.02
TERMUX_PKG_SRCURL=https://github.com/wiz-lang/wiz.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"

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

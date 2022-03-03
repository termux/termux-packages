TERMUX_PKG_HOMEPAGE=https://www.flameeyes.com/projects/unpaper
TERMUX_PKG_DESCRIPTION="A post-processing tool for scanned sheets of paper"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=e5154081c1c944719ff6ba70a8c114d1656ea799
TERMUX_PKG_VERSION=2022.01.21
TERMUX_PKG_SRCURL=https://github.com/unpaper/unpaper.git
TERMUX_PKG_DEPENDS="ffmpeg"
TERMUX_PKG_GIT_BRANCH=main

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

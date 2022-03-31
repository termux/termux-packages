TERMUX_PKG_HOMEPAGE=https://github.com/Akianonymus/gdrive-downloader
TERMUX_PKG_DESCRIPTION="Download a gdrive folder or file easily, shell ftw."
TERMUX_PKG_LICENSE="Unlicense"
_COMMIT=b8ea865e56ad70cee368a322720dc723295db2c0
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2022.03.15
TERMUX_PKG_SRCURL=$TERMUX_PKG_HOMEPAGE.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS='bash, curl'
TERMUX_PKG_PLATFORM_INDEPENDENT=true

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

termux_step_make_install() {
	install -D release/bash/* -t "$TERMUX_PREFIX/bin"
}

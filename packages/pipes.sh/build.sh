TERMUX_PKG_HOMEPAGE=https://github.com/pipeseroni/pipes.sh
TERMUX_PKG_DESCRIPTION="Animated pipes terminal screensaver"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@Efreak"
_COMMIT=581792d4e0ea51e15889ba14a85db1bc9727b83d
TERMUX_PKG_VERSION=2018.04.22
TERMUX_PKG_SRCURL=git+https://github.com/pipeseroni/pipes.sh
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS=bash
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
	cd "$TERMUX_PKG_SRCDIR"
	make install PREFIX=$TERMUX_PREFIX
}

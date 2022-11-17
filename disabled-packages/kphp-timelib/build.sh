TERMUX_PKG_HOMEPAGE=https://github.com/derickr/timelib
TERMUX_PKG_DESCRIPTION="timelib 2020.02 library fork for KPHP"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.rst"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=59ee82faa8d9ed42b1b9b9339e0b989cc929cd4a
TERMUX_PKG_VERSION=2021.03.01
TERMUX_PKG_SRCURL=https://github.com/VKCOM/timelib.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_NO_STATICSPLIT=true

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

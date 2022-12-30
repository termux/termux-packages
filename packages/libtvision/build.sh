TERMUX_PKG_HOMEPAGE=https://github.com/magiblot/tvision
TERMUX_PKG_DESCRIPTION="A modern port of Turbo Vision 2.0 with Unicode support"
TERMUX_PKG_LICENSE="Public Domain, MIT"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=7cdc0c8d45bdc94fbbc0f0cb349904dbaf8efb56
TERMUX_PKG_VERSION=2022.12.06
TERMUX_PKG_SRCURL=git+https://github.com/magiblot/tvision
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libc++, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DTV_BUILD_EXAMPLES=OFF
-DTV_BUILD_USING_GPM=OFF
-DTV_OPTIMIZE_BUILD=OFF
"

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

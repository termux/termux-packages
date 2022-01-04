TERMUX_PKG_HOMEPAGE=https://github.com/coin-or/CoinUtils
TERMUX_PKG_DESCRIPTION="An open-source collection of classes and helper functions for COIN-OR projects"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=9035d7a1b5b6daed9b067f16f440420e4477abac
TERMUX_PKG_VERSION=2022.01.03
TERMUX_PKG_SRCURL=https://github.com/coin-or/CoinUtils.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libc++"

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

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}

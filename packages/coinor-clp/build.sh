TERMUX_PKG_HOMEPAGE=https://github.com/coin-or/Clp
TERMUX_PKG_DESCRIPTION="An open-source linear programming solver"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=899ed6d5f9de24ddb0c31761f9551c6c861dad92
TERMUX_PKG_VERSION=2022.01.01
TERMUX_PKG_SRCURL=https://github.com/coin-or/Clp.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libc++, libcoinor-osi, libcoinor-utils"

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

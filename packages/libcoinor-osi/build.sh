TERMUX_PKG_HOMEPAGE=https://github.com/coin-or/Osi
TERMUX_PKG_DESCRIPTION="An abstract base class to a generic linear programming (LP) solver"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=01ada0ee8d423b4401ac04418c8300a04dd2beaf
TERMUX_PKG_VERSION=2022.01.01
TERMUX_PKG_SRCURL=https://github.com/coin-or/Osi.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libc++, libcoinor-utils"

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

TERMUX_PKG_HOMEPAGE=https://github.com/istathar/slashtime
TERMUX_PKG_DESCRIPTION="A small program which displays the time in various places"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=6a6c2ce075f085f9892cd6d89e423c811f21a4a8
TERMUX_PKG_VERSION=2022.04.20
TERMUX_PKG_SRCURL=https://github.com/istathar/slashtime.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

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

termux_step_configure() {
	:
}

termux_step_make() {
	:
}

termux_step_make_install() {
	install -Dm700 -T slashtime.pl $TERMUX_PREFIX/bin/slashtime
}

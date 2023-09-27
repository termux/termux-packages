TERMUX_PKG_HOMEPAGE=https://github.com/istathar/slashtime
TERMUX_PKG_DESCRIPTION="A small program which displays the time in various places"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=aa4e96d36ec6e4cb56e3567c560c1c209f4fd492
TERMUX_PKG_VERSION=2023.01.04
TERMUX_PKG_SRCURL=git+https://github.com/istathar/slashtime
TERMUX_PKG_SHA256=c15f9df0cee790156460a624cedc4c5b4367aba46b48d729f987e9b4d32a8132
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

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
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

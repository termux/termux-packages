TERMUX_PKG_HOMEPAGE=https://github.com/magiblot/tvision
TERMUX_PKG_DESCRIPTION="A modern port of Turbo Vision 2.0 with Unicode support"
TERMUX_PKG_LICENSE="Public Domain, MIT"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=423aeb568a181ffebb3695859654385950588a93
TERMUX_PKG_VERSION=2025.10.31
TERMUX_PKG_SRCURL=git+https://github.com/magiblot/tvision
TERMUX_PKG_SHA256=f812a2f18597e7610ac0f819104b4c7a72c15fdf2cad77f4b3d9e6853c562e05
TERMUX_PKG_AUTO_UPDATE=false
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

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

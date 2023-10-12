TERMUX_PKG_HOMEPAGE=https://github.com/magiblot/tvision
TERMUX_PKG_DESCRIPTION="A modern port of Turbo Vision 2.0 with Unicode support"
TERMUX_PKG_LICENSE="Public Domain, MIT"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=115924552b4ab8030543ce14e64475f44c758457
TERMUX_PKG_VERSION=2023.01.29
TERMUX_PKG_SRCURL=git+https://github.com/magiblot/tvision
TERMUX_PKG_SHA256=4e80413e75820962c42da49e22aad97b949f8b729a28d4562d4e3148f5b072f5
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

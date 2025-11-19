TERMUX_PKG_HOMEPAGE=https://phantomjs.org/
TERMUX_PKG_DESCRIPTION="A headless WebKit scriptable with JavaScript"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE.BSD"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=0a0b0facb16acfbabb7804822ecaf4f4b9dce3d2
TERMUX_PKG_VERSION=2020.07.13
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/ariya/phantomjs
TERMUX_PKG_SHA256=5603bfc300c6bf712db3d8e7dea6b0f8d97eb470b8ab589e9cec3b290ed56d57
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, qt5-qtwebkit"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_FORCE_CMAKE=true

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

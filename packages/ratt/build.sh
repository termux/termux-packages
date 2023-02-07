TERMUX_PKG_HOMEPAGE=https://git.sr.ht/~ghost08/ratt
TERMUX_PKG_DESCRIPTION="A tool for converting websites to rss/atom feeds"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=ff3adafce8ce29bd98221a65f87e7e10f2c7ba25
TERMUX_PKG_VERSION=2022.10.30
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://git.sr.ht/~ghost08/ratt
TERMUX_PKG_SHA256=caacb0f19581bc06380be3fff8387aa32ee098394921f3ac75c1e18d6fe913c3
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"

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

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

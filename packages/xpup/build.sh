TERMUX_PKG_HOMEPAGE=https://github.com/ericchiang/xpup
TERMUX_PKG_DESCRIPTION="pup for XML"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=3c408621ad9b5693323acd7d1b455f78444e0c5f
TERMUX_PKG_VERSION=2021.12.26
TERMUX_PKG_SRCURL=git+https://github.com/ericchiang/xpup
TERMUX_PKG_GIT_BRANCH=master
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

termux_step_make() {
	termux_setup_golang

	go mod init
	go mod tidy
	go build
}

termux_step_make_install() {
	install -Dm700 xpup $TERMUX_PREFIX/bin/
}

TERMUX_PKG_HOMEPAGE=https://trantor.is/
TERMUX_PKG_DESCRIPTION="Command line client for the imperial library of trantor"
TERMUX_PKG_LICENSE="WTFPL"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=b117aef9c64348b1ef262a99316f1e51328efe18
TERMUX_PKG_VERSION=2021.05.18
TERMUX_PKG_SRCURL=https://gitlab.com/trantor/hummin.git
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

	go mod init || :
	go mod tidy
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin hummin
}

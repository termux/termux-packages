TERMUX_PKG_HOMEPAGE=https://aditya-k2.github.io/gomp/
TERMUX_PKG_DESCRIPTION="MPD client inspired by ncmpcpp with builtin cover-art view and LastFM integration"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=0c0cbbf950c84f44092dbeb70d3ae2c095b79b9e
TERMUX_PKG_VERSION=2022.12.30
TERMUX_PKG_SRCURL=git+https://github.com/aditya-K2/gomp
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="mpd"

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
	export GOFLAGS="-buildmode=pie -trimpath -mod=readonly -modcacherw"
	go build -o gomp
}

termux_step_make_install() {
	install -Dm700 gomp $TERMUX_PREFIX/bin/
}

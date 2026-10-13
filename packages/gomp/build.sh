TERMUX_PKG_HOMEPAGE=https://aditya-k2.github.io/gomp/
TERMUX_PKG_DESCRIPTION="MPD client inspired by ncmpcpp with builtin cover-art view and LastFM integration"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=3887b24f1104805eb53af7b2e94c542d14c25f3f
TERMUX_PKG_VERSION=2024.07.01
TERMUX_PKG_SRCURL=git+https://github.com/aditya-K2/gomp
TERMUX_PKG_SHA256=a2b34b83ffe003fb6033ef48486e6f5a7c671449c29281d3d05d3bac97c97a64
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="mpd"
TERMUX_PKG_AUTO_UPDATE=false

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

termux_step_make() {
	termux_setup_golang
	export GOFLAGS="-buildmode=pie -trimpath -mod=readonly -modcacherw"
	go build -o gomp
}

termux_step_make_install() {
	install -Dm700 gomp $TERMUX_PREFIX/bin/
}

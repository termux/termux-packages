TERMUX_PKG_HOMEPAGE=https://github.com/ajeetdsouza/clidle
TERMUX_PKG_DESCRIPTION="Play Wordle over SSH"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=fe27556c1147333af2cfe81cbc40f4f60ea191ee
TERMUX_PKG_VERSION=2022.05.25
TERMUX_PKG_SRCURL=git+https://github.com/ajeetdsouza/clidle
TERMUX_PKG_SHA256=68bec2f8445fe78d6295811d30adadc1aa16abce9911f65e619da67d75e3fdd5
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_GROUPS="games"
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

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin clidle
}

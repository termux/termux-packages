TERMUX_PKG_HOMEPAGE="https://github.com/mop-tracker/mop"
TERMUX_PKG_DESCRIPTION="Stock market tracker"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=aec04cfc78c77b116ab4fe2f4ed5034c5c004f58
_COMMIT_DATE=20251228
TERMUX_PKG_VERSION="2025.12.28"
TERMUX_PKG_SRCURL="git+https://github.com/mop-tracker/mop"
TERMUX_PKG_SHA256=faf8d6c5119e4086976183ec2725ce9200fe9aa7fb130d2f921fe16a3afbe946
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_BUILD_IN_SRC=true
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

	go mod init || :
	go mod tidy

	go build -o mop $TERMUX_PKG_SRCDIR/cmd/mop
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}/bin" mop
}

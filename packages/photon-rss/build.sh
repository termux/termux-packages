TERMUX_PKG_HOMEPAGE=https://git.sr.ht/~ghost08/photon
TERMUX_PKG_DESCRIPTION="An RSS/Atom reader with the focus on speed, usability and a bit of unix philosophy"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=02e0faa0a40f4772e996b58ec203337f7c0dd51c
TERMUX_PKG_VERSION=2022.12.01
TERMUX_PKG_SRCURL=git+https://git.sr.ht/~ghost08/photon
TERMUX_PKG_SHA256=a832e72b66c8edc45af2b1f7a68e484879d8c1f3f5c980faafeb46073a469a1d
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

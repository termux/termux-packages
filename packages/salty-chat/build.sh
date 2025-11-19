TERMUX_PKG_HOMEPAGE=https://salty.im/
TERMUX_PKG_DESCRIPTION="A secure, easy, self-hosted messaging"
TERMUX_PKG_LICENSE="MIT, WTFPL"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=5a5510e8869fa878381deb30fedc1d2c92c33311
_COMMIT_DATE=20251006
TERMUX_PKG_VERSION="0.0.22-p${_COMMIT_DATE}"
TERMUX_PKG_SRCURL=git+https://git.mills.io/saltyim/saltyim
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_SHA256=ab1d28e52e449ee41379f724b5aea9d50a9e82f31a5f00fb92fe3f062254d71e
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="VERSION=${TERMUX_PKG_VERSION}"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout "$_COMMIT"

	local pdate="p$(git log -1 --format=%cs | sed 's/-//g')"
	if [[ "$TERMUX_PKG_VERSION" != *"${pdate}" ]]; then
		echo -n "ERROR: The version string \"$TERMUX_PKG_VERSION\" is"
		echo -n " different from what is expected to be; should end"
		echo " with \"${pdate}\"."
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

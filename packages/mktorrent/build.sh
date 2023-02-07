TERMUX_PKG_HOMEPAGE=https://github.com/Rudde/mktorrent
TERMUX_PKG_DESCRIPTION="command line utility to create BitTorrent metainfo files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=de7d011b35458de1472665f50b96c9cf6c303f39
_COMMIT_DATE=20210130
TERMUX_PKG_VERSION=1.1-p${_COMMIT_DATE}
TERMUX_PKG_SRCURL=git+https://github.com/Rudde/mktorrent
TERMUX_PKG_SHA256=2e1c61fceaef47f0fdf68d73580edea104ab044040c339f844d44fe119507d78
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

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

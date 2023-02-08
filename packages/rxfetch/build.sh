TERMUX_PKG_HOMEPAGE=https://github.com/Mangeshrex/rxfetch
TERMUX_PKG_DESCRIPTION="A custom system info fetching tool"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@PeroSar"
_COMMIT=fa70e5aa0eaa72914fc3b170b83a2b67c049cbef
TERMUX_PKG_VERSION=2023.01.07
TERMUX_PKG_SRCURL=git+https://github.com/mangeshrex/rxfetch
TERMUX_PKG_SHA256=c7034d2ab3c591ed048bff33b651d7b3423307b2017336bca215fee1f0878681
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_DEPENDS="bash"
TERMUX_PKG_CONFLICTS="rxfetch-termux"
TERMUX_PKG_REPLACES="rxfetch-termux"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout "$_COMMIT"

	local ver=$(git log -1 --format=%cs | sed 's/-/./g')
	if [ "$ver" != "$TERMUX_PKG_VERSION" ]; then
		echo "Error: Expected version: $ver"
		echo "Found version: $TERMUX_PKG_VERSION"
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin rxfetch
}

TERMUX_PKG_HOMEPAGE=https://github.com/Mangeshrex/rxfetch
TERMUX_PKG_DESCRIPTION="A custom system info fetching tool"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@PeroSar"
_COMMIT=88c71a6210ba11cc914ca7fd568ae2e3aa0a65cc
TERMUX_PKG_VERSION=2022.11.13
TERMUX_PKG_SRCURL=https://github.com/mangeshrex/rxfetch.git
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
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin rxfetch
}

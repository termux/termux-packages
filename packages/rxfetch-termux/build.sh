TERMUX_PKG_HOMEPAGE=https://github.com/mayTermux/rxfetch-termux
TERMUX_PKG_DESCRIPTION="Fork of rxfetch for termux"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@PeroSar"
_COMMIT=4cbd2981d650a53748cdf84a23e22dfbf4bf0ea7
TERMUX_PKG_VERSION=2022.04.01
TERMUX_PKG_SRCURL=https://github.com/mayTermux/rxfetch-termux.git
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_DEPENDS="bash"
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

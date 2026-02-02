TERMUX_PKG_HOMEPAGE=https://github.com/yt-dlp/ejs
TERMUX_PKG_DESCRIPTION="External JavaScript for yt-dlp supporting many runtimes"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.0"
TERMUX_PKG_SRCURL="https://github.com/yt-dlp/ejs/releases/download/$TERMUX_PKG_VERSION/yt_dlp_ejs-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=3c67e0beb6f9f3603fbcb56f425eabaa37c52243d90d20ccbcce1dd941cfbd07
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="build, hatchling, hatch-vcs"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS='nodejs | nodejs-lts, python'
if (( TERMUX_ARCH_BITS == 64 )); then
	TERMUX_PKG_DEPENDS='deno | nodejs | nodejs-lts, python'
fi

termux_step_make() {
	termux_setup_nodejs
	npm install
	python -m build --wheel --no-isolation
}

termux_step_make_install() {
	local _whl="yt_dlp_ejs-$TERMUX_PKG_VERSION-py3-none-any.whl"
	pip install --force-reinstall --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR/dist/$_whl"
}

TERMUX_PKG_HOMEPAGE=https://github.com/yt-dlp/ejs
TERMUX_PKG_DESCRIPTION="External JavaScript for yt-dlp supporting many runtimes"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.0"
TERMUX_PKG_SRCURL="https://github.com/yt-dlp/ejs/releases/download/$TERMUX_PKG_VERSION/yt_dlp_ejs-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=50ad37866aa6d1d069ab20f6d0fccf41e7f07f249b4feb80eff7a66fd5928de7
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
	npm install --frozen-lockfile
	npm run bundle
	python -m build --wheel --no-isolation
}

termux_step_make_install() {
	local _whl="yt_dlp_ejs-$TERMUX_PKG_VERSION-py3-none-any.whl"
	pip install --force-reinstall --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR/dist/$_whl"
}

TERMUX_PKG_HOMEPAGE=https://github.com/ValleyBell/libvgm
TERMUX_PKG_DESCRIPTION="A more modular rewrite of most components from VGMPlay"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=fd7da37b96b5937a0bb5a41bacbae0a0ef59069f
TERMUX_PKG_VERSION=2022.11.25
TERMUX_PKG_SRCURL=https://github.com/ValleyBell/libvgm.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libao, pulseaudio"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_FORCE_CMAKE=true

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi
}

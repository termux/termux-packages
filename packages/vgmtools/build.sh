TERMUX_PKG_HOMEPAGE=https://github.com/vgmrips/vgmtools
TERMUX_PKG_DESCRIPTION="A collection of tools for the VGM file format"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=b9216623ffb9219c46a7a10669175c7a4c8cd946
TERMUX_PKG_VERSION=2022.12.03
TERMUX_PKG_SRCURL=https://github.com/vgmrips/vgmtools.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libandroid-glob, libc++, zlib"

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

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

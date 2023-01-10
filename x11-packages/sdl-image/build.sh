TERMUX_PKG_HOMEPAGE=https://www.libsdl.org/projects/SDL_image/
TERMUX_PKG_DESCRIPTION="A simple library to load images of various formats as SDL surfaces"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=633dc522f5114f6d473c910dace62e8ca27a1f7d
_COMMIT_DATE=20220527
TERMUX_PKG_VERSION=1.2.12-p${_COMMIT_DATE}
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=git+https://github.com/libsdl-org/SDL_image
TERMUX_PKG_GIT_BRANCH=SDL-1.2
TERMUX_PKG_DEPENDS="libjpeg-turbo, libpng, libtiff, libwebp, sdl"

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
}

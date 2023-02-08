TERMUX_PKG_HOMEPAGE=https://www.libsdl.org/projects/SDL_image/
TERMUX_PKG_DESCRIPTION="A simple library to load images of various formats as SDL surfaces"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=9a5bd2d522c8e0f5a92ba7c8c1bac123228611d0
_COMMIT_DATE=20230130
TERMUX_PKG_VERSION=1.2.12-p${_COMMIT_DATE}
TERMUX_PKG_SRCURL=git+https://github.com/libsdl-org/SDL_image
TERMUX_PKG_SHA256=9b1cbb2fa68632242d49841a9341af1b432e4f8129d3c91b90420b486f5dd158
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

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

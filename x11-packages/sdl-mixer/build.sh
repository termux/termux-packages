TERMUX_PKG_HOMEPAGE=https://www.libsdl.org/projects/SDL_mixer/release-1.2.html
TERMUX_PKG_DESCRIPTION="A simple multi-channel audio mixer"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=7804621c533dddfe970e97c94c4ea72d48ed7f48
_COMMIT_DATE=20221010
TERMUX_PKG_VERSION=1.2.12-p${_COMMIT_DATE}
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/libsdl-org/SDL_mixer
TERMUX_PKG_SHA256=473a39b04f1a2ec29a22e3eafaafeee9704129f117044d17c591646648b540cd
TERMUX_PKG_GIT_BRANCH=SDL-1.2
TERMUX_PKG_DEPENDS="libflac, libvorbis, sdl"

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

TERMUX_PKG_HOMEPAGE=https://github.com/dirkvdb/ffmpegthumbnailer
TERMUX_PKG_DESCRIPTION="Lightweight video thumbnailer that can be used by file managers"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=1b5a77983240bcf00a4ef7702c07bcd8f4e5f97c
_COMMIT_DATE=20240104
TERMUX_PKG_VERSION=2.2.2-p${_COMMIT_DATE}
TERMUX_PKG_SRCURL=git+https://github.com/dirkvdb/ffmpegthumbnailer
TERMUX_PKG_SHA256=cd768067ddedbdf1574d4e3ac7db7475f2f2539be1faedc515d61eddef6903a6
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="ffmpeg, libc++, libjpeg-turbo, libpng"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_GIO=ON
-DENABLE_THUMBNAILER=ON
"

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

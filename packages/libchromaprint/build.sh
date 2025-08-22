TERMUX_PKG_HOMEPAGE=https://acoustid.org/chromaprint
TERMUX_PKG_DESCRIPTION="C library for generating audio fingerprints used by AcoustID"
TERMUX_PKG_LICENSE="LGPL-2.1, MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=6ce6c4daeb299e88a8f497232bf02f4898f165a4
_COMMIT_DATE=20250625
TERMUX_PKG_VERSION=1.5.1-p${_COMMIT_DATE}
TERMUX_PKG_SRCURL=git+https://github.com/acoustid/chromaprint
TERMUX_PKG_SHA256=029733cbea5e50ebdd208137207d1d26ff7919991357245229cd29042e9cda75
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="fftw, libc++"
TERMUX_PKG_BUILD_DEPENDS="ffmpeg"
TERMUX_PKG_BREAKS="chromaprint (<< 1.5.1-p20250625)"
TERMUX_PKG_REPLACES="chromaprint (<< 1.5.1-p20250625)"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_BUILD_TYPE=Release
-DBUILD_SHARED_LIBS=ON
-DFFT_LIB=fftw3
-DBUILD_TOOLS=ON
-DBUILD_TESTS=OFF
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

TERMUX_PKG_HOMEPAGE=https://acoustid.org/chromaprint
TERMUX_PKG_DESCRIPTION="C library for generating audio fingerprints used by AcoustID"
TERMUX_PKG_LICENSE="LGPL-2.1, MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=aa67c95b9e486884a6d3ee8b0c91207d8c2b0551
_COMMIT_DATE=20221217
TERMUX_PKG_VERSION=1.5.1-p${_COMMIT_DATE}
TERMUX_PKG_SRCURL=git+https://github.com/acoustid/chromaprint
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="ffmpeg, libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_BUILD_TYPE=Release
-DBUILD_SHARED_LIBS=ON
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
}

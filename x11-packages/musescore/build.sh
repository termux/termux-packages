TERMUX_PKG_HOMEPAGE=https://musescore.org/
TERMUX_PKG_DESCRIPTION="A music score editor/player"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# first qt-6.9-compatible commit in master branch
_COMMIT=b64bb9418c16d91f853fefe960ad42363e16664d
_COMMIT_DATE=20250515
TERMUX_PKG_VERSION="4.5.2-p${_COMMIT_DATE}"
TERMUX_PKG_SRCURL=git+https://github.com/musescore/MuseScore
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_SHA256=e47d3161870894f390f3a217e8f95b34774a1c8f39e413f3c4e133b264798978
TERMUX_PKG_BUILD_DEPENDS="qt6-qttools"
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, qt6-qtnetworkauth, qt6-qt5compat, qt6-qtscxml, qt6-qtsvg, libopus, libopusenc, libsndfile, alsa-lib"
# re-enable when a qt6.9-compatible stable release comes
#TERMUX_PKG_AUTO_UPDATE=true
#TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
#TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+(\.\d+)?'
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DCMAKE_PROGRAM_PATH=${TERMUX_PREFIX}/opt/qt6/cross/bin/;${TERMUX_PREFIX}/opt/qt6/cross/lib/qt6/bin/
-DMUE_RUN_LRELEASE=OFF
-DMUE_COMPILE_USE_SYSTEM_OPUS=TRUE
-DMUE_COMPILE_USE_SYSTEM_OPUSENC=TRUE
-DMUSE_ENABLE_UNIT_TESTS=FALSE
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

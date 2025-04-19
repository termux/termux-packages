TERMUX_PKG_HOMEPAGE=http://opentimeline.io/
TERMUX_PKG_DESCRIPTION="Open Source API and interchange format for editorial timeline information."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.17.0"
TERMUX_PKG_SRCURL="git+https://github.com/AcademySoftwareFoundation/OpenTimelineIO"
TERMUX_PKG_SHA256=235cb5c259aa3c87baca0b899aa88dbba204a93615c0fa50adfa4d382ec7dd6e
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="imath"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DOTIO_AUTOMATIC_SUBMODULES=OFF
-DOTIO_DEPENDENCIES_INSTALL=OFF
-DOTIO_FIND_IMATH=ON
-DOTIO_SHARED_LIBS=ON
"

termux_step_post_get_source() {
	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]] ; then
		termux_error_exit "Checksum mismatch for source files.\nExpected: ${TERMUX_PKG_SHA256}\nActual:   ${s%% *}"
	fi
}

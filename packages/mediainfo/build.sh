TERMUX_PKG_HOMEPAGE=https://mediaarea.net/en/MediaInfo
TERMUX_PKG_DESCRIPTION="Command-line utility for reading information from media files"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="../../../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="24.06"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/MediaArea/MediaInfo/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7f72926d0a4df4f2bf9e32a061c686695aa0f99f8715aa43682399486ff8961e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libc++, libmediainfo, libzen"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR="${TERMUX_PKG_SRCDIR}/Project/GNU/CLI"
	TERMUX_PKG_BUILDDIR="${TERMUX_PKG_SRCDIR}"
	cd "${TERMUX_PKG_SRCDIR}"
	./autogen.sh
}

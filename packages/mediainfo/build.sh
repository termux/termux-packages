TERMUX_PKG_HOMEPAGE=https://mediaarea.net/en/MediaInfo
TERMUX_PKG_DESCRIPTION="Command-line utility for reading information from media files"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="../../../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.01"
TERMUX_PKG_SRCURL=https://github.com/MediaArea/MediaInfo/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cec53d8aa143376965d8da72cfaaed4e1e432e23a19ed26cbdf8e69a14e93365
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libc++, libmediainfo, libzen"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR="${TERMUX_PKG_SRCDIR}/Project/GNU/CLI"
	TERMUX_PKG_BUILDDIR="${TERMUX_PKG_SRCDIR}"
	cd "${TERMUX_PKG_SRCDIR}"
	./autogen.sh
}

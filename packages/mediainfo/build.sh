TERMUX_PKG_HOMEPAGE=https://mediaarea.net/en/MediaInfo
TERMUX_PKG_DESCRIPTION="Command-line utility for reading information from media files"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="../../../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=22.09
TERMUX_PKG_SRCURL=https://mediaarea.net/download/source/mediainfo/${TERMUX_PKG_VERSION}/mediainfo_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=67f301276a2b82d76cb9f4bd525caa51d2dc6d4359fce774fbd5f25f1d513044
TERMUX_PKG_DEPENDS="libandroid-support, libc++, libmediainfo, libzen"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR="${TERMUX_PKG_SRCDIR}/Project/GNU/CLI"
	TERMUX_PKG_BUILDDIR="${TERMUX_PKG_SRCDIR}"
	cd "${TERMUX_PKG_SRCDIR}"
	./autogen.sh
}

TERMUX_PKG_HOMEPAGE=https://github.com/c0re100/qBittorrent-Enhanced-Edition
TERMUX_PKG_DESCRIPTION="A Qt based BitTorrent client"
TERMUX_PKG_LICENSE="GPL-2.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@zhongerxll"
TERMUX_PKG_VERSION="4.6.5.10"
TERMUX_PKG_SRCURL=https://github.com/c0re100/qBittorrent-Enhanced-Edition/archive/refs/tags/release-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9330b6c331975c53ef17f106c430c70e4853e44d523a0c0d3d2fd60f7c112019
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_CONFLICTS="qbittorrent"
TERMUX_PKG_DEPENDS="libicu, libtorrent-rasterbar, openssl, qt5-qtbase"
TERMUX_PKG_BUILD_DEPENDS="qt5-qttools, qt5-qtsvg, boost, libc++"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+\.\d+\.\d+'
TERMUX_PKG_EXTRA_CONFIGURE_ARGS='
-DSTACKTRACE=OFF
-DCMAKE_BUILD_TYPE=Release
-DBUILD_SHARED_LIBS=off
'

# based on the secondary `-shared` build in `libncnn`
termux_step_post_make_install() {
	echo -e "termux - building qbittorrent-nox for arch ${TERMUX_ARCH}..."
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+='-DGUI=OFF'
	termux_step_configure
	termux_step_make
	termux_step_make_install
}

TERMUX_PKG_HOMEPAGE=https://www.qbittorrent.org/
TERMUX_PKG_DESCRIPTION="A Qt based BitTorrent client"
TERMUX_PKG_LICENSE="GPL-2.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="4.6.5"
TERMUX_PKG_SRCURL=https://github.com/qbittorrent/qBittorrent/archive/refs/tags/release-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f330042fd0b27530b4a7b70b5d7ab356b2c9246393761df3b06891dc9dd8c106
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_DEPENDS="libicu, libtorrent-rasterbar, openssl, qt5-qtbase"
TERMUX_PKG_BUILD_DEPENDS="qt5-qttools, qt5-qtsvg, boost, libc++"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+\.\d+'
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

TERMUX_PKG_HOMEPAGE=https://www.qbittorrent.org/
TERMUX_PKG_DESCRIPTION="A Qt6 based BitTorrent client"
TERMUX_PKG_LICENSE="GPL-2.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="5.3.0"
TERMUX_PKG_SRCURL="https://github.com/qbittorrent/qBittorrent/archive/refs/tags/release-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=dcb5273496117ebf264fc1fc7936de8707374f07dcee0805228ac5adb403a465
TERMUX_PKG_DEPENDS="libc++, libtorrent-rasterbar, openssl, qt6-qtbase, zlib"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtsvg, qt6-qttools, boost"
TERMUX_PKG_RECOMMENDS="python"
TERMUX_PKG_SUGGESTS="jackett"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=latest-release-tag
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+\.\d+(?!beta|rc)'
TERMUX_PKG_EXTRA_CONFIGURE_ARGS='
-DBUILD_SHARED_LIBS=OFF
-DCMAKE_BUILD_TYPE=Release
-DSTACKTRACE=OFF
'

# based on the secondary `-shared` build in `libncnn`
termux_step_post_make_install() {
	echo -e "termux - building qbittorrent-nox for arch ${TERMUX_ARCH}..."
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+='-DGUI=OFF'
	termux_step_configure
	termux_step_make
	termux_step_make_install
}

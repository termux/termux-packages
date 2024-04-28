TERMUX_PKG_HOMEPAGE=https://qbitorrent.org/
TERMUX_PKG_DESCRIPTION="An advanced BitTorrent client programmed in C++, based on Qt toolkit and libtorrent-rasterbar, w/o gui"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.6.4"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/qbittorrent/qbittorrent/qbittorrent-${TERMUX_PKG_VERSION}/qbittorrent-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c3af27bee38740364e79452d275b0a456baba10bca8093e0e71017406ec7b5a1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libtorrent-rasterbar, openssl"
TERMUX_PKG_BUILD_DEPENDS="qt5-qttools, qt5-qtsvg, boost, libc++"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-D VERBOSE_CONFIGURE=ON
-D STACKTRACE=OFF
-DGUI=OFF
-DCMAKE_BUILD_TYPE=Release
-DBUILD_SHARED_LIBS=off
-Dstatic_runtime=on
-DCMAKE_INSTALL_PREFIX="${TERMUX_PREFIX}"
"
termux_step_pre_configure() {
	./configure --disable-gui
}			

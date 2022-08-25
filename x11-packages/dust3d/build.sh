TERMUX_PKG_HOMEPAGE=https://dust3d.org/
TERMUX_PKG_DESCRIPTION="3D watertight modeling software"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/huxingyi/dust3d/archive/${TERMUX_PKG_VERSION}-rc.6.tar.gz
TERMUX_PKG_SHA256=171a12dad39ffd40551126e304a05f036958145fab2a45631929831e2c6bbee9
TERMUX_PKG_DEPENDS="qt5-qtbase, cgal, qt5-qttools-cross-tools"

termux_step_make_install() {
	cd "$TERMUX_PKG_SRCDIR"
	"${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" -config release "QMAKE_LFLAGS+=-Wl,--sort-common,--as-needed,-z,relro,-z,now" dust3d.pro -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"
	make install	
}

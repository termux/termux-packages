TERMUX_PKG_HOMEPAGE=http://assimp.sourceforge.net/index.html
TERMUX_PKG_DESCRIPTION="Library to import various well-known 3D model formats in an uniform manner"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.2.2
TERMUX_PKG_SRCURL=https://github.com/assimp/assimp/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ad76c5d86c380af65a9d9f64e8fc57af692ffd80a90f613dfc6bd945d0b80bb4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_BREAKS="assimp-dev"
TERMUX_PKG_REPLACES="assimp-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DASSIMP_BUILD_SAMPLES=OFF"

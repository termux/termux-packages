TERMUX_PKG_HOMEPAGE=https://assimp.sourceforge.net/index.html
TERMUX_PKG_DESCRIPTION="Library to import various well-known 3D model formats in an uniform manner"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.0.4"
TERMUX_PKG_SRCURL="https://github.com/assimp/assimp/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=afa5487efdd285661afa842c85187cd8c541edad92e8d4aa85be4fca7476eccc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers"
TERMUX_PKG_BREAKS="assimp-dev"
TERMUX_PKG_REPLACES="assimp-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DASSIMP_BUILD_SAMPLES=OFF"

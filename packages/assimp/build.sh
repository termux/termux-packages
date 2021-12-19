TERMUX_PKG_HOMEPAGE=http://assimp.sourceforge.net/index.html
TERMUX_PKG_DESCRIPTION="Library to import various well-known 3D model formats in an uniform manner"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.1.4
TERMUX_PKG_SRCURL=https://github.com/assimp/assimp/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=bd32cdc27e1f8b7ac09d914ab92dd81d799c97e9e47315c1f40dcb7c6f7938c6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, zlib"
TERMUX_PKG_BREAKS="assimp-dev"
TERMUX_PKG_REPLACES="assimp-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DASSIMP_BUILD_SAMPLES=OFF"

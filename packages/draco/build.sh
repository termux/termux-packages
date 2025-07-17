TERMUX_PKG_HOMEPAGE=https://google.github.io/draco/
TERMUX_PKG_DESCRIPTION="Library for compressing and decompressing 3D geometric meshes and point clouds"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.7"
TERMUX_PKG_SRCURL="https://github.com/google/draco/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=bf6b105b79223eab2b86795363dfe5e5356050006a96521477973aba8f036fe1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"

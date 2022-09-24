TERMUX_PKG_HOMEPAGE="https://github.com/flexible-collision-library/fcl"
TERMUX_PKG_DESCRIPTION="Flexible collision library"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Pooya Moradi <pvonmoradi@gmail.com>"
TERMUX_PKG_VERSION="0.7.0"
TERMUX_PKG_SRCURL="https://github.com/flexible-collision-library/fcl/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=90409e940b24045987506a6b239424a4222e2daf648c86dd146cbcb692ebdcbc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_BUILD_DEPENDS="eigen"
TERMUX_PKG_DEPENDS="libandroid-support, libccd, octomap"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DFCL_STATIC_LIBRARY=OFF
-DFCL_USE_HOST_NATIVE_ARCH=OFF
-DFCL_WITH_OCTOMAP=ON
"

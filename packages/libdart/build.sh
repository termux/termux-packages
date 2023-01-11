TERMUX_PKG_HOMEPAGE="https://github.com/dartsim/dart"
TERMUX_PKG_DESCRIPTION="Dynamic Animation and Robotics Toolkit"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="Pooya Moradi <pvonmoradi@gmail.com>"
TERMUX_PKG_VERSION="6.12.2"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://github.com/dartsim/dart/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=db1b3ef888d37f0dbc567bc291ab2cdb5699172523a58dd5a5fe513ee38f83b0
TERMUX_PKG_AUTO_UPDATE=true
# FIXME add ipopt, nlopt, snopt  after a proper FORTRAN compiler is
# added (hence LAPACK)
# FIXME why pagmo is not detected by build system?
# FIXME add urdfdom
TERMUX_PKG_DEPENDS="libc++, eigen, assimp, libccd, libfcl, boost, libbullet, libode, libpagmo, octomap-static, libtinyxml2"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DDART_VERBOSE=ON
-DBUILD_SHARED_LIBS=ON
-DDART_ENABLE_SIMD=OFF
-DDART_BUILD_GUI_OSG=OFF
-DDART_BUILD_DARTPY=ON
-DDART_CODECOV=OFF
-DDART_FAST_DEBUG=OFF
-DDART_FORCE_COLORED_OUTPUT=OFF
"


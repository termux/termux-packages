TERMUX_PKG_HOMEPAGE="https://dartsim.github.io/"
TERMUX_PKG_DESCRIPTION="Dynamic Animation and Robotics Toolkit"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="Pooya Moradi <pvonmoradi@gmail.com>"
TERMUX_PKG_VERSION="6.16.4"
TERMUX_PKG_SRCURL="https://github.com/dartsim/dart/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=d7af169aca40f63e8fae0541421bdbf48a36bcc5e236414d0d3ae2bf4eada489
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
# FIXME add ipopt, nlopt, snopt  after a proper FORTRAN compiler is
# added (hence LAPACK)
# FIXME why pagmo is not detected by build system?
# FIXME add urdfdom
TERMUX_PKG_DEPENDS="libc++, eigen, assimp, libccd, libfcl, fmt, libspdlog, libbullet, libode, libpagmo, octomap, libtinyxml2"
TERMUX_PKG_BUILD_DEPENDS="octomap-static"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DDART_VERBOSE=ON
-DBUILD_SHARED_LIBS=ON
-DDART_ENABLE_SIMD=OFF
-DDART_BUILD_GUI_OSG=OFF
-DDART_BUILD_DARTPY=OFF
-DDART_CODECOV=OFF
-DDART_FAST_DEBUG=OFF
-DDART_FORCE_COLORED_OUTPUT=OFF
-DDART_DOWNLOAD_DEPENDENT_PACKAGES=OFF
-DDART_TREAT_WARNINGS_AS_ERRORS=OFF
"

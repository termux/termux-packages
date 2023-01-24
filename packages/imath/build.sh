TERMUX_PKG_HOMEPAGE=https://imath.readthedocs.io/
TERMUX_PKG_DESCRIPTION="Library for vector/matrix and math operations, plus the half type"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
# Align the version with `openexr` package.
TERMUX_PKG_VERSION=3.1.6
_OPENEXR_MINIMUM_VERSION=${TERMUX_PKG_VERSION}
if [ "${TERMUX_PKG_VERSION}" = "3.1.6" ]; then
	# Imath 3.1.6 is known to work with OpenEXR 3.1.5:
	_OPENEXR_MINIMUM_VERSION=3.1.5
fi
TERMUX_PKG_SRCURL=https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ea5592230f5ab917bea3ceab266cf38eb4aa4a523078d46eac0f5a89c52304db
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="openexr (<< ${_OPENEXR_MINIMUM_VERSION})"
TERMUX_PKG_CONFLICTS="openexr2"
TERMUX_PKG_REPLACES="openexr2"

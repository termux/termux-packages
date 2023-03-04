TERMUX_PKG_HOMEPAGE=https://imath.readthedocs.io/
TERMUX_PKG_DESCRIPTION="Library for vector/matrix and math operations, plus the half type"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
# Align the version with `openexr` package.
TERMUX_PKG_VERSION=3.1.7
_OPENEXR_MINIMUM_VERSION=${TERMUX_PKG_VERSION}
if [ "${TERMUX_PKG_VERSION}" = "3.1.7" ]; then
	# Imath 3.1.7 is known to work with OpenEXR 3.1.5:
	_OPENEXR_MINIMUM_VERSION=3.1.5
fi
TERMUX_PKG_SRCURL=https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bff1fa140f4af0e7f02c6cb78d41b9a7d5508e6bcdfda3a583e35460eb6d4b47
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="openexr (<< ${_OPENEXR_MINIMUM_VERSION})"
TERMUX_PKG_CONFLICTS="openexr2"
TERMUX_PKG_REPLACES="openexr2"

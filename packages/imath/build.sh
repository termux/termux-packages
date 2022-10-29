TERMUX_PKG_HOMEPAGE=https://imath.readthedocs.io/
TERMUX_PKG_DESCRIPTION="Library for vector/matrix and math operations, plus the half type"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
# Align the version with `openexr` package.
TERMUX_PKG_VERSION=3.1.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1e9c7c94797cf7b7e61908aed1f80a331088cc7d8873318f70376e4aed5f25fb
TERMUX_PKG_DEPENDS="libc++, zlib"
TERMUX_PKG_BREAKS="openexr (<< ${TERMUX_PKG_VERSION})"
TERMUX_PKG_CONFLICTS="openexr2"
TERMUX_PKG_REPLACES="openexr2"

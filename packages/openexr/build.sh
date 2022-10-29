TERMUX_PKG_HOMEPAGE=https://www.openexr.com/
TERMUX_PKG_DESCRIPTION="Provides the specification and reference implementation of the EXR file format"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
# Align the version with `imath` package.
TERMUX_PKG_VERSION=3.1.5
TERMUX_PKG_SRCURL=https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=93925805c1fc4f8162b35f0ae109c4a75344e6decae5a240afdfce25f8a433ec
TERMUX_PKG_DEPENDS="imath (>= ${TERMUX_PKG_VERSION}), libc++, zlib"
TERMUX_PKG_CONFLICTS="openexr2"
TERMUX_PKG_REPLACES="openexr2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTING=OFF
"

termux_step_post_massage() {
	shopt -s nullglob
	local f
	for f in lib/libImath*; do
		termux_error_exit "File ${f} should not be contained in this package."
	done
	shopt -u nullglob
}

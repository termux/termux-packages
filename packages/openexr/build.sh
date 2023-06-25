TERMUX_PKG_HOMEPAGE=https://www.openexr.com/
TERMUX_PKG_DESCRIPTION="Provides the specification and reference implementation of the EXR file format"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1.8
TERMUX_PKG_SRCURL=https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3ff47111ef7e5da6f69330e66e1e90ae620b79df1cedf2512bb9bffe86c2c617
TERMUX_PKG_DEPENDS="imath, libc++, zlib"
TERMUX_PKG_CONFLICTS="openexr2"
TERMUX_PKG_REPLACES="openexr2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTING=OFF
"

termux_step_pre_configure() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=29

	local a
	for a in LIBTOOL_CURRENT LIBTOOL_AGE; do
		local _${a}=$(sed -En 's/^set\(OPENEXR_'"${a}"'\s+([0-9]+).*/\1/p' \
				CMakeLists.txt)
	done
	local v=$(( _LIBTOOL_CURRENT - _LIBTOOL_AGE ))
	if [ ! "${_LIBTOOL_CURRENT}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_post_massage() {
	shopt -s nullglob
	local f
	for f in lib/libImath*; do
		termux_error_exit "File ${f} should not be contained in this package."
	done
	shopt -u nullglob
}

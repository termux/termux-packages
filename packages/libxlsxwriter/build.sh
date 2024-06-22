TERMUX_PKG_HOMEPAGE=https://libxlsxwriter.github.io/
TERMUX_PKG_DESCRIPTION="A C library for creating Excel XLSX files"
TERMUX_PKG_LICENSE="BSD 2-Clause, BSD 3-Clause, ZLIB, MPL-2.0, MIT, Public Domain"
TERMUX_PKG_LICENSE_FILE="License.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.7"
TERMUX_PKG_SRCURL=https://github.com/jmcnamara/libxlsxwriter/archive/refs/tags/RELEASE_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1f378e25d8bb5be258d3e04d3d24b8c23ff21bf206e6e206661844a96ca25eda
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+.\d+.\d+"
TERMUX_PKG_DEPENDS="libminizip"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DUSE_SYSTEM_MINIZIP=ON
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=6

	local v=$(sed -En 's/.*LXW_SOVERSION .*"(.*)".*/\1/p' \
			include/xlsxwriter.h)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

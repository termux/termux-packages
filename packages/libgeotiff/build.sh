TERMUX_PKG_HOMEPAGE="https://github.com/OSGeo/libgeotiff"
TERMUX_PKG_DESCRIPTION="Library for handling TIFF for georeferenced raster imagery"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.3"
TERMUX_PKG_SRCURL="https://github.com/OSGeo/libgeotiff/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=62eb2cc2f41136bc61b2152ad321fe2e8b3a8ad47794369c685346ea1dc71b1b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libtiff, proj"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_TIFF=ON
-DWITH_TOWGS84=ON
-DBUILD_SHARED_LIBS=ON
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=5

	local e=$(sed -En 's/^libgeotiff_la_LDFLAGS\s*=.*\s+-version-info\s+([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
			libgeotiff/Makefile.am)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/libgeotiff"
}

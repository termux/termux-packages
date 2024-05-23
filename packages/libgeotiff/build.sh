TERMUX_PKG_HOMEPAGE="https://github.com/OSGeo/libgeotiff"
TERMUX_PKG_DESCRIPTION="Library for handling TIFF for georeferenced raster imagery"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.2"
TERMUX_PKG_SRCURL="https://github.com/OSGeo/libgeotiff/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=8e872c10663c9cb662484760d6e319e6f6e9cab3cdd6b833898d330a81e8dba7
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

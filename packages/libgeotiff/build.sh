TERMUX_PKG_HOMEPAGE="https://github.com/OSGeo/libgeotiff"
TERMUX_PKG_DESCRIPTION="Library for handling TIFF for georeferenced raster imagery"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.4"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/OSGeo/libgeotiff/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=c581ff502c6b1dc012fad1031d95293ea5f5ff250d9502de382aced8c7d28565
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

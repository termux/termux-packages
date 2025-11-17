TERMUX_PKG_HOMEPAGE=https://gdal.org
TERMUX_PKG_DESCRIPTION="A translator library for raster and vector geospatial data formats"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.TXT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.12.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.osgeo.org/gdal/${TERMUX_PKG_VERSION}/gdal-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=428c19fff818bbb4136766cfee86fae2eebd3620806aa40af21844f4f0b2dbcf
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="giflib, json-c, libc++, libcurl, libexpat, libfreexl, libgeos, libiconv, libjpeg-turbo, libjxl, liblzma, libpng, libspatialite, libsqlite, libwebp, libxml2, netcdf-c (>= 4.9.3), openjpeg, openssl, proj, postgresql, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="json-c-static"
TERMUX_PKG_BREAKS="gdal-dev"
TERMUX_PKG_REPLACES="gdal-dev"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
-DCMAKE_INSTALL_INCLUDEDIR=$TERMUX__PREFIX__INCLUDE_SUBDIR
-DGDAL_USE_JXL=ON
-DGDAL_USE_TIFF_INTERNAL=ON
-DGDAL_USE_GEOTIFF_INTERNAL=ON
-DBUILD_PYTHON_BINDINGS=OFF
"

termux_step_pre_configure () {
	if [ "${TERMUX_ARCH}" = "arm" ]; then
		## -mfpu=neon causes build failure on ARM.
		CFLAGS="${CFLAGS/-mfpu=neon/} -mfpu=vfp"
		CXXFLAGS="${CXXFLAGS/-mfpu=neon/} -mfpu=vfp"
	fi
}

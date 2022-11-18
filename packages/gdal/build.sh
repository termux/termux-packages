TERMUX_PKG_HOMEPAGE=https://gdal.org
TERMUX_PKG_DESCRIPTION="A translator library for raster and vector geospatial data formats"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.TXT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.5.3
TERMUX_PKG_SRCURL=https://download.osgeo.org/gdal/${TERMUX_PKG_VERSION}/gdal-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d32223ddf145aafbbaec5ccfa5dbc164147fb3348a3413057f9b1600bb5b3890
TERMUX_PKG_DEPENDS="json-c, libc++, libcurl, libexpat, libgeos, libiconv, libjxl, libpng, libspatialite, libsqlite, libwebp, netcdf-c, openjpeg, openssl, proj, postgresql"
TERMUX_PKG_BREAKS="gdal-dev"
TERMUX_PKG_REPLACES="gdal-dev"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-expat=$TERMUX_PREFIX
--with-jxl=$TERMUX_PREFIX
--with-libjson-c=$TERMUX_PREFIX
--with-libtiff=internal
--with-spatialite=$TERMUX_PREFIX
--with-sqlite3=$TERMUX_PREFIX
--with-rename-internal-libtiff-symbols=no
--with-rename-internal-libgeotiff-symbols=no
--with-rename-internal-shapelib-symbols=no
"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}

TERMUX_PKG_HOMEPAGE=https://gdal.org
TERMUX_PKG_DESCRIPTION="A translator library for raster and vector geospatial data formats"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.TXT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.3.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.osgeo.org/gdal/${TERMUX_PKG_VERSION}/gdal-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=190c8f4b56afc767f43836b2a5cd53cc52ee7fdc25eb78c6079c5a244e28efa7
TERMUX_PKG_DEPENDS="libc++, openjpeg, libcurl, libtiff, libpng, proj, libiconv, libsqlite, libgeos, libspatialite, libexpat, postgresql, netcdf-c"
TERMUX_PKG_BREAKS="gdal-dev"
TERMUX_PKG_REPLACES="gdal-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-sqlite3=$TERMUX_PREFIX
--with-spatialite=$TERMUX_PREFIX
--with-expat=$TERMUX_PREFIX
"

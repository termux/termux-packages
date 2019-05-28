TERMUX_PKG_HOMEPAGE=https://gdal.org
TERMUX_PKG_DESCRIPTION="A translator library for raster and vector geospatial data formats"
TERMUX_PKG_MAINTAINER="Bjoern Schilberg @BjoernSchilberg"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_VERSION=3.0.0
TERMUX_PKG_SRCURL=https://download.osgeo.org/gdal/${TERMUX_PKG_VERSION}/gdal-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ad316fa052d94d9606e90b20a514b92b2dd64e3142dfdbd8f10981a5fcd5c43e
TERMUX_PKG_DEPENDS="openjpeg, libcurl, libtiff, libpng, proj, libiconv, libsqlite, libgeos"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-sqlite3=$TERMUX_PREFIX"

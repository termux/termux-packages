TERMUX_PKG_HOMEPAGE=https://gdal.org
TERMUX_PKG_DESCRIPTION="A translator library for raster and vector geospatial data formats"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.TXT"
TERMUX_PKG_MAINTAINER="Bjoern Schilberg @BjoernSchilberg"
TERMUX_PKG_VERSION=3.0.1
TERMUX_PKG_SRCURL=https://download.osgeo.org/gdal/${TERMUX_PKG_VERSION}/gdal-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=45b4ae25dbd87282d589eca76481c426f72132d7a599556470d5c38263b09266
TERMUX_PKG_DEPENDS="libc++, openjpeg, libcurl, libtiff, libpng, proj, libiconv, libsqlite, libgeos"
TERMUX_PKG_BREAKS="gdal-dev"
TERMUX_PKG_REPLACES="gdal-dev"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-sqlite3=$TERMUX_PREFIX"

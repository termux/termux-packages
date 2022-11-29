TERMUX_PKG_HOMEPAGE=https://postgis.net
TERMUX_PKG_DESCRIPTION="Spatial database extender for PostgreSQL object-relational database"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.3.2
TERMUX_PKG_SRCURL=https://download.osgeo.org/postgis/source/postgis-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9a2a219da005a1730a39d1959a1c7cec619b1efb009b65be80ffc25bad299068
TERMUX_PKG_DEPENDS="gdal, json-c, libc++, libgeos, libiconv, libprotobuf-c, libxml2, pcre2, postgresql, proj"

# both configure script and Makefile(s) look for files in current
# directory rather than srcdir, so need to build in source
TERMUX_PKG_BUILD_IN_SRC=true

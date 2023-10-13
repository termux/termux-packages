TERMUX_PKG_HOMEPAGE=https://osm2pgsql.org/
TERMUX_PKG_DESCRIPTION="osm2pgsql imports OpenStreetMap (OSM) data into a PostgreSQL/PostGIS database"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.9.2"
TERMUX_PKG_SRCURL=https://github.com/openstreetmap/osm2pgsql/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dc30a3ad9a27f944e4169be9a8e07ee09711901536ddc8fcf4a292bd3aec51d9
TERMUX_PKG_DEPENDS="boost, libbz2, libc++, libexpat, liblua54, postgresql, proj, zlib, nlohmann-json"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DEXTERNAL_FMT=OFF
"

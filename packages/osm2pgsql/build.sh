TERMUX_PKG_HOMEPAGE=https://osm2pgsql.org/
TERMUX_PKG_DESCRIPTION="osm2pgsql imports OpenStreetMap (OSM) data into a PostgreSQL/PostGIS database"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.1"
TERMUX_PKG_SRCURL=https://github.com/openstreetmap/osm2pgsql/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b9d5c95ccc928aafc3c6caccb8b5bc19c4d48a5d1640cada07388d0dbf171ecc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, libbz2, libc++, libexpat, liblua54, postgresql, proj, zlib, nlohmann-json"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DEXTERNAL_FMT=OFF
"

TERMUX_PKG_HOMEPAGE=https://osm2pgsql.org/
TERMUX_PKG_DESCRIPTION="osm2pgsql imports OpenStreetMap (OSM) data into a PostgreSQL/PostGIS database"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.0"
TERMUX_PKG_SRCURL=https://github.com/openstreetmap/osm2pgsql/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a02ad5c57a9db5376e2c797560dc6d35be37109283d7be7b124528cb5de00331
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, libbz2, libc++, libexpat, liblua54, postgresql, proj, zlib, nlohmann-json"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DEXTERNAL_FMT=OFF
"

TERMUX_PKG_HOMEPAGE=https://osm2pgsql.org/
TERMUX_PKG_DESCRIPTION="osm2pgsql imports OpenStreetMap (OSM) data into a PostgreSQL/PostGIS database"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/openstreetmap/osm2pgsql/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=567dad078f8a66d6d706ac1876b5251b688109d16974909d89ce2056d6e9f258
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, libbz2, libc++, libexpat, lua54, postgresql, proj, zlib, nlohmann-json"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DEXTERNAL_FMT=OFF
"

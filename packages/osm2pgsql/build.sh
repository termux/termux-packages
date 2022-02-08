TERMUX_PKG_HOMEPAGE=https://osm2pgsql.org/
TERMUX_PKG_DESCRIPTION="osm2pgsql imports OpenStreetMap (OSM) data into a PostgreSQL/PostGIS database"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.0
TERMUX_PKG_SRCURL=https://github.com/openstreetmap/osm2pgsql/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0ec8b58ab972ac8356185af4161270c1b625a77299f09e5fb7f45e616ef1a9a5
TERMUX_PKG_DEPENDS="libexpat, proj, bzip2, zlib, postgresql, lua54"
TERMUX_PKG_BUILD_DEPENDS="boost"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DEXTERNAL_FMT=OFF
"

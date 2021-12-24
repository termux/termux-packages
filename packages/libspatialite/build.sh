TERMUX_PKG_HOMEPAGE=https://www.gaia-gis.it/fossil/libspatialite
TERMUX_PKG_DESCRIPTION="SQLite extension to support spatial data types and operations"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.0.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.gaia-gis.it/gaia-sins/libspatialite-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=eecbc94311c78012d059ebc0fae86ea5ef6eecb13303e6e82b3753c1b3409e98
TERMUX_PKG_DEPENDS="libgeos, proj, libfreexl, libsqlite, libxml2, librttopo"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-minizip"
# Can't find generated config file spatialite/gaiaconfig.h
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export LDFLAGS+=" -llog"
}

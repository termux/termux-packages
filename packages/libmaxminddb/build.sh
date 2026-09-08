TERMUX_PKG_HOMEPAGE=https://dev.maxmind.com/geoip/geoip2/
TERMUX_PKG_DESCRIPTION="MaxMind GeoIP2 database - library and utilities"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.14.0"
TERMUX_PKG_SRCURL=https://github.com/maxmind/libmaxminddb/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=90de11531cd1bfe22af6669b789c2e09bc31c6b77ef1beb5422003836b8484db
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libmaxminddb-dev"
TERMUX_PKG_REPLACES="libmaxminddb-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-tests"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0.0.7

	local v=$(sed -En 's/^set\(MAXMINDDB_SOVERSION\s+([0-9.]+).*/\1/p' \
			CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	./bootstrap
}

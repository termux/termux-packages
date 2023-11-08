TERMUX_PKG_HOMEPAGE=https://dev.maxmind.com/geoip/geoip2/
TERMUX_PKG_DESCRIPTION="MaxMind GeoIP2 database - library and utilities"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.0"
TERMUX_PKG_SRCURL=https://github.com/maxmind/libmaxminddb/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7fcf9190fc8338d7a877b433dd8fc09ee07724dc4d1dc17e6ca11df79c47f6a9
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

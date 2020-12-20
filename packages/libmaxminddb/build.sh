TERMUX_PKG_HOMEPAGE=https://dev.maxmind.com/geoip/geoip2/
TERMUX_PKG_DESCRIPTION="MaxMind GeoIP2 database - library and utilities"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.3
TERMUX_PKG_SRCURL=https://github.com/maxmind/libmaxminddb/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ad6f941696fa9f452ca62676e6837378ea19ee86637c5f2fe8af2bc530bdde9d
TERMUX_PKG_BREAKS="libmaxminddb-dev"
TERMUX_PKG_REPLACES="libmaxminddb-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-tests"

termux_step_pre_configure() {
	./bootstrap
}

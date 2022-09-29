TERMUX_PKG_HOMEPAGE=https://dev.maxmind.com/geoip/geoip2/
TERMUX_PKG_DESCRIPTION="MaxMind GeoIP2 database - library and utilities"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.0"
TERMUX_PKG_SRCURL=https://github.com/maxmind/libmaxminddb/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6600ac35812c67c7f1e4857a416becfe387cd4de35044436be1885305bc6b3bd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libmaxminddb-dev"
TERMUX_PKG_REPLACES="libmaxminddb-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-tests"

termux_step_pre_configure() {
	./bootstrap
}

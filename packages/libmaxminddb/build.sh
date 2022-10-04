TERMUX_PKG_HOMEPAGE=https://dev.maxmind.com/geoip/geoip2/
TERMUX_PKG_DESCRIPTION="MaxMind GeoIP2 database - library and utilities"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.1"
TERMUX_PKG_SRCURL=https://github.com/maxmind/libmaxminddb/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=4ed9c409667f0adeb3eca653780785ad04713b8a87f2fcfbb31967b213826322
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libmaxminddb-dev"
TERMUX_PKG_REPLACES="libmaxminddb-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-tests"

termux_step_pre_configure() {
	./bootstrap
}

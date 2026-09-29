TERMUX_PKG_HOMEPAGE=https://github.com/libpwquality/libpwquality
TERMUX_PKG_DESCRIPTION="Library for password quality checking and generating random passwords"
TERMUX_PKG_LICENSE="BSD 3-Clause, GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.5"
TERMUX_PKG_SRCURL="https://github.com/libpwquality/libpwquality/releases/download/libpwquality-${TERMUX_PKG_VERSION}/libpwquality-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=6fcf18b75d305d99d04d2e42982ed5b787a081af2842220ed63287a2d6a10988
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-cracklib-check
--disable-python-bindings
--disable-static
"

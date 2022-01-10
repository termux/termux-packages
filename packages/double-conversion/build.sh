TERMUX_PKG_HOMEPAGE=https://github.com/google/double-conversion
TERMUX_PKG_DESCRIPTION="Binary-decimal and decimal-binary routines for IEEE doubles"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.2.0
TERMUX_PKG_SRCURL=https://github.com/google/double-conversion/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=3dbcdf186ad092a8b71228a5962009b5c96abde9a315257a3452eb988414ea3b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_SHARED_LIBS=ON"

TERMUX_PKG_HOMEPAGE=https://github.com/google/double-conversion
TERMUX_PKG_DESCRIPTION="Binary-decimal and decimal-binary routines for IEEE doubles"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1.7
TERMUX_PKG_SRCURL=https://github.com/google/double-conversion/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a0204d6ab48223f2c8f53a932014e7f245125e7a5267764b1fbeebe4fa0ee8b9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_SHARED_LIBS=ON"

TERMUX_PKG_HOMEPAGE=https://github.com/google/double-conversion
TERMUX_PKG_DESCRIPTION="Binary-decimal and decimal-binary routines for IEEE doubles"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.1"
TERMUX_PKG_SRCURL=https://github.com/google/double-conversion/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e40d236343cad807e83d192265f139481c51fc83a1c49e406ac6ce0a0ba7cd35
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_SHARED_LIBS=ON"

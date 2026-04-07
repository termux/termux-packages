TERMUX_PKG_HOMEPAGE=https://github.com/Martchus/cpp-utilities
TERMUX_PKG_DESCRIPTION="Useful C++ classes and routines such as argument parser, IO and conversion utilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.34.0"
TERMUX_PKG_SRCURL=https://github.com/Martchus/cpp-utilities/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7cb228606e79b9a33244cea062674d6339b0db00081f6cae9b3b7d12619fa7db
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, libc++, libiconv"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"

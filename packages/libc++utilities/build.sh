TERMUX_PKG_HOMEPAGE=https://github.com/Martchus/cpp-utilities
TERMUX_PKG_DESCRIPTION="Useful C++ classes and routines such as argument parser, IO and conversion utilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.30.0"
TERMUX_PKG_SRCURL=https://github.com/Martchus/cpp-utilities/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9d594108109de7cd2dbb399451e69f68851a7f983e2671a0a4766211c380d1b4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, libc++, libiconv"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"

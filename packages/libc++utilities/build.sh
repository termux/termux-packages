TERMUX_PKG_HOMEPAGE=https://github.com/Martchus/cpp-utilities
TERMUX_PKG_DESCRIPTION="Useful C++ classes and routines such as argument parser, IO and conversion utilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.24.1"
TERMUX_PKG_SRCURL=https://github.com/Martchus/cpp-utilities/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=86cceb6983789144e2fe0101642836be7bce45a22879248ad8d8938e4adccfc6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, libc++, libiconv"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"

TERMUX_PKG_HOMEPAGE=https://github.com/zxing-cpp/zxing-cpp
TERMUX_PKG_DESCRIPTION="An open-source, multi-format 1D/2D barcode image processing library implemented in C++"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.0"
TERMUX_PKG_SRCURL=https://github.com/zxing-cpp/zxing-cpp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=64e4139103fdbc57752698ee15b5f0b0f7af9a0331ecbdc492047e0772c417ba
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DZXING_EXAMPLES=OFF
-DZXING_BLACKBOX_TESTS=OFF
"

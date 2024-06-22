TERMUX_PKG_HOMEPAGE=https://github.com/nu-book/zxing-cpp
TERMUX_PKG_DESCRIPTION="An open-source, multi-format 1D/2D barcode image processing library implemented in C++"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.1"
TERMUX_PKG_SRCURL=https://github.com/nu-book/zxing-cpp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=02078ae15f19f9d423a441f205b1d1bee32349ddda7467e2c84e8f08876f8635
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_EXAMPLES=OFF
-DBUILD_BLACKBOX_TESTS=OFF
"

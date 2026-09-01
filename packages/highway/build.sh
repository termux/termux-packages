TERMUX_PKG_HOMEPAGE=https://github.com/google/highway
TERMUX_PKG_DESCRIPTION="Performance-portable, length-agnostic SIMD with runtime dispatch"
TERMUX_PKG_LICENSE="Apache-2.0, BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.0"
TERMUX_PKG_SRCURL="https://github.com/google/highway/releases/download/${TERMUX_PKG_VERSION}/highway-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=36f672ab48ddb3c8555e9e89e16fe400cd7d16c6eb455a1a3d0c146a63ababdc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_CONFLICTS="libjxl (<< 0.12.0-1)"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"

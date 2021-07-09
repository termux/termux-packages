TERMUX_PKG_HOMEPAGE=https://code.videolan.org/videolan/dav1d/
TERMUX_PKG_DESCRIPTION="AV1 cross-platform decoder focused on speed and correctness"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.0
TERMUX_PKG_SRCURL=https://downloads.videolan.org/pub/videolan/dav1d/${TERMUX_PKG_VERSION}/dav1d-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=cfae88e8067c9b2e5b96d95a7a00155c353376fe9b992a96b4336e0eab19f9f6
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denable_asm=false
-Denable_tools=false
-Denable_tests=false
"

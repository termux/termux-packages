TERMUX_PKG_HOMEPAGE=https://code.videolan.org/videolan/dav1d/
TERMUX_PKG_DESCRIPTION="AV1 cross-platform decoder focused on speed and correctness"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.1
TERMUX_PKG_SRCURL=https://downloads.videolan.org/pub/videolan/dav1d/${TERMUX_PKG_VERSION}/dav1d-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a35d6468013eb14e8093ea463594f8b89aba1775a3005fc9ec6fa36b2d2c71d7
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denable_asm=false
-Denable_tools=false
-Denable_tests=false
"

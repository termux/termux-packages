TERMUX_PKG_HOMEPAGE=https://code.videolan.org/videolan/dav1d/
TERMUX_PKG_DESCRIPTION="AV1 cross-platform decoder focused on speed and correctness"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.2
TERMUX_PKG_SRCURL=https://downloads.videolan.org/pub/videolan/dav1d/${TERMUX_PKG_VERSION}/dav1d-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e3235ab6c43c0135b0db1d131e1923fad4c84db9d85683e30b91b33a52d61c71
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denable_asm=false
-Denable_tools=false
-Denable_tests=false
"

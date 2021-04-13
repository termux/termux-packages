TERMUX_PKG_HOMEPAGE=https://code.videolan.org/videolan/dav1d/
TERMUX_PKG_DESCRIPTION="AV1 cross-platform decoder focused on speed and correctness"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.2
TERMUX_PKG_SRCURL=https://downloads.videolan.org/pub/videolan/dav1d/${TERMUX_PKG_VERSION}/dav1d-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3dd91d96b44e9d8ba7e82ad9e730d6c579ab5e19edca0db857a60f5ae6a0eb13
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denable_asm=false
-Denable_tools=false
-Denable_tests=false
"

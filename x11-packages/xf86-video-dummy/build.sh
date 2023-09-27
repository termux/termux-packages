TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.org dummy video driver"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
# Please, do not update it to 0.4.0.
TERMUX_PKG_VERSION=0.3.8
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/driver/xf86-video-dummy-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ee5ad51e80c8cc90d4c76ac3dec2269a3c769f4232ed418b29d60d618074631b
TERMUX_PKG_DEPENDS="xorg-server"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

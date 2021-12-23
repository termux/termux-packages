TERMUX_PKG_HOMEPAGE=https://liboil.freedesktop.org/wiki/
TERMUX_PKG_DESCRIPTION="Liboil is a library of simple functions that are optimized for various CPUs"
TERMUX_PKG_LICENSE=custom
TERMUX_PKG_LICENSE_FILE=COPYING
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.3.17
TERMUX_PKG_SRCURL=https://liboil.freedesktop.org/download/liboil-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=105f02079b0b50034c759db34b473ecb5704ffa20a5486b60a8b7698128bfc69
TERMUX_PKG_DEPENDS="gtk-doc"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--build=aarch64-unknown-linux-gnu"

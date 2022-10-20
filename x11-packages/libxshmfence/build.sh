TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="A library that exposes a event API on top of Linux futexes"
# License: HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.1
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libxshmfence-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1129f95147f7bfe6052988a087f1b7cb7122283d2c47a7dbf7135ce0df69b4f8
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-futex"

TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="A library that exposes a event API on top of Linux futexes"
# License: HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.2
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libxshmfence-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=870df257bc40b126d91b5a8f1da6ca8a524555268c50b59c0acd1a27f361606f
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-futex"

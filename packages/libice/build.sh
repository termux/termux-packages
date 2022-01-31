# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Inter-Client Exchange library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.10
TERMUX_PKG_REVISION=15
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libICE-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=6f86dce12cf4bcaf5c37dddd8b1b64ed2ddf1ef7b218f22b9942595fb747c348
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros, xtrans"

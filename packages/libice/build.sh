# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Inter-Client Exchange library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libICE-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=02d2fc40d81180bd4aae73e8356acfa2a7671e8e8b472e6a7bfa825235ab225b
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros, xtrans"

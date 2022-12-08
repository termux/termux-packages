# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Inter-Client Exchange library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.1
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libICE-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=03e77afaf72942c7ac02ccebb19034e6e20f456dcf8dddadfeb572aa5ad3e451
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros, xtrans"

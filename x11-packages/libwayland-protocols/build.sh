TERMUX_PKG_HOMEPAGE=https://wayland.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Wayland protocols library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.28
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/${TERMUX_PKG_VERSION}/downloads/wayland-protocols-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c7659fb6bf14905e68ef605f898de60d1c066bf66dbea92798573dddec1535b6
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=false
"

TERMUX_PKG_HOMEPAGE=https://wayland.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Wayland protocols library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.31
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/${TERMUX_PKG_VERSION}/downloads/wayland-protocols-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a07fa722ed87676ec020d867714bc9a2f24c464da73912f39706eeef5219e238
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=false
"

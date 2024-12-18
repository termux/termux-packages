TERMUX_PKG_HOMEPAGE=https://wayland.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Wayland protocols library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.38"
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/${TERMUX_PKG_VERSION}/downloads/wayland-protocols-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ff17292c05159d2b20ce6cacfe42d7e31a28198fa1429a769b03af7c38581dbe
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_DEPENDS="libwayland, libwayland-cross-scanner"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=false
"

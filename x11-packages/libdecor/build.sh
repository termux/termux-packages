TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/libdecor/libdecor
TERMUX_PKG_DESCRIPTION="Client-side decorations library for Wayland clients"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.3"
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/libdecor/libdecor/-/archive/${TERMUX_PKG_VERSION}/libdecor-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=21a471e3f48088d3fd8ecc5999c45258a32198782c0157482f7ebe82de42f79c
# gtk3 dependency makes libdecor a "x11" package
TERMUX_PKG_DEPENDS="dbus, glib, gtk3, libcairo, libwayland, libxkbcommon, pango"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddemo=false
-Ddbus=enabled
-Dinstall_demo=false
-Dgtk=enabled
"

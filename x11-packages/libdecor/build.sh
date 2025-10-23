TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/libdecor/libdecor
TERMUX_PKG_DESCRIPTION="Client-side decorations library for Wayland clients"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.4"
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/libdecor/libdecor/-/archive/${TERMUX_PKG_VERSION}/libdecor-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1fb3ee6c7c9e238d240772517753bedb2e09e29d21514fb86f19724fccb58cc1
# gtk3 dependency makes libdecor a "x11" package
TERMUX_PKG_DEPENDS="dbus, glib, gtk3, libcairo, libwayland, libxkbcommon, pango"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddemo=false
-Ddbus=enabled
-Dinstall_demo=false
-Dgtk=enabled
"

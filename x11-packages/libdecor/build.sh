TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/libdecor/libdecor
TERMUX_PKG_DESCRIPTION="Client-side decorations library for Wayland clients"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1.1
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/libdecor/libdecor/-/archive/${TERMUX_PKG_VERSION}/libdecor-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=82adece5baeb6194292b0d1a91b4b3d10da41115f352a5e6c5844b20b88a0512
TERMUX_PKG_DEPENDS="libwayland, libwayland-protocols, dbus,  pango, gtk3, libxkbcommon"
TERMUX_PKG_EXTRA_CONFIG_ARGS="-Ddemo=False -Dgtk"

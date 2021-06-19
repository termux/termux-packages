TERMUX_PKG_HOMEPAGE=https://marco.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="MATE default window manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.24.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/marco/releases/download/v$TERMUX_PKG_VERSION/marco-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=498350cb12fc4d9c7c4a0355102c17b50043fbab258d11ad41b7d698b4f042a7
TERMUX_PKG_DEPENDS="libcanberra, glib, gtk3, zenity"
TERMUX_PKG_RM_AFTER_INSTALL="share/glib-2.0/schemas/gschemas.compiled"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ZENITY=${TERMUX_PREFIX}/bin/zenity
"

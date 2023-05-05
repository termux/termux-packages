TERMUX_PKG_HOMEPAGE=https://marco.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="MATE default window manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.26.2
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/marco/releases/download/v$TERMUX_PKG_VERSION/marco-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=12f1a254fe1072f0304884711e089a5682780a011593402ed38de6b9480e07a3
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libcanberra, libice, libsm, libx11, libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libxinerama, libxrandr, libxrender, libxres, mate-desktop, pango, startup-notification, zenity, zlib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ZENITY=${TERMUX_PREFIX}/bin/zenity
"

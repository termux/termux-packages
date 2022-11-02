TERMUX_PKG_HOMEPAGE=https://marco.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="MATE default window manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.26.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/marco/releases/download/v$TERMUX_PKG_VERSION/marco-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=f63c08cd8b07450ab3e33a04605c4f9e69522358884273b3cbcf30275eee5b05
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libcanberra, libice, libltdl, libsm, libvorbis, libx11, libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libxinerama, libxrandr, libxrender, mate-desktop, pango, startup-notification, zenity"
TERMUX_PKG_RM_AFTER_INSTALL="share/glib-2.0/schemas/gschemas.compiled"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ZENITY=${TERMUX_PREFIX}/bin/zenity
"

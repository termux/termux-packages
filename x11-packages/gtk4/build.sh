TERMUX_PKG_HOMEPAGE=https://www.gtk.org/
TERMUX_PKG_DESCRIPTION="GObject-based multi-platform GUI toolkit"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.3.0
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/gtk/-/archive/$TERMUX_PKG_VERSION/gtk-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=cea146508fcbf2c234247e1be34a556d0bbde3db30e3faea9e5189735f5551a4
TERMUX_PKG_DEPENDS="adwaita-icon-theme, atk, coreutils, desktop-file-utils, gdk-pixbuf, glib, glib-bin, graphene, gtk-update-icon-cache, libcairo, libepoxy, libxcomposite, libxcursor, libxdamage, libxfixes, libxi, libxinerama, libxrandr, pango, shared-mime-info, ttf-dejavu, libxkbcommon"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_RM_AFTER_INSTALL="share/glib-2.0/schemas/gschemas.compiled"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dwayland-backend=false
-Ddemos=false
-Dbuild-examples=false
-Dbuild-tests=false
-Dvulkan=disabled
-Dprint-cups=disabled
-Dprint-cloudprint=disabled
"

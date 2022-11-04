TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/zenity
TERMUX_PKG_DESCRIPTION="a rewrite of gdialog, the GNOME port of dialog"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=3.43
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/zenity/${_MAJOR_VERSION}/zenity-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=b0d7ca1e0c1868fa18f05c210260d8a7be1f08ee13b7f5cfdbab9b61fa16f833
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libnotify, libx11, pango, webkit2gtk-4.1"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlibnotify=true
-Dwebkitgtk=true
"

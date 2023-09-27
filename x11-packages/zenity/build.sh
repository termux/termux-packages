TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/zenity
TERMUX_PKG_DESCRIPTION="a rewrite of gdialog, the GNOME port of dialog"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=3.44
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.2
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/zenity/${_MAJOR_VERSION}/zenity-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=3fb5b8b1044d3d129262d3c54cf220eb7f76bc21bd5ac6d96ec115cd3518300e
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libnotify, libx11, pango, webkit2gtk-4.1"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlibnotify=true
-Dwebkitgtk=true
"

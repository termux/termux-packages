TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/dconf
TERMUX_PKG_DESCRIPTION="dconf is a simple key/value storage system that is heavily optimised for reading"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_VERSION=0.36
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/dconf.git
TERMUX_PKG_GIT_BRANCH=dconf-$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="dbus, glib-bin"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="-Dbash_completion=false -Dvapi=false"


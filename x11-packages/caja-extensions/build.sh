TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="Set of extensions for Caja, the MATE file manager"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.0"
TERMUX_PKG_SRCURL="https://github.com/mate-desktop/caja-extensions/releases/download/v$TERMUX_PKG_VERSION/caja-extensions-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=d2986c5e0740835fe271cfbd5823eeeaf03291af1763203f4700abb8109e3175
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="caja, dbus-glib, gettext, gst-plugins-base, imagemagick, samba"
TERMUX_PKG_BUILD_DEPENDS="autoconf-archive, glib, mate-common, python, gst-plugins-base"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-upnp
--disable-gksu
"

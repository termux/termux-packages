TERMUX_PKG_HOMEPAGE=https://pidgin.im/
TERMUX_PKG_DESCRIPTION="Multi-protocol instant messaging client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.14.13"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/pidgin/pidgin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=120049dc8e17e09a2a7d256aff2191ff8491abb840c8c7eb319a161e2df16ba8
TERMUX_PKG_DEPENDS="atk, dbus, dbus-glib, fontconfig, freetype, gdk-pixbuf, glib, gstreamer, gtk2, harfbuzz, libcairo, libgnt, libgnutls, libice, libidn, libsasl, libsm, libx11, libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libxinerama, libxml2, libxrandr, libxrender, libxss, ncurses, pango, tcl"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-gevolution
--disable-gtkspell
--disable-vv
--disable-meanwhile
--disable-avahi
--disable-perl
--disable-nm
"

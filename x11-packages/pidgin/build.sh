TERMUX_PKG_HOMEPAGE=https://pidgin.im/
TERMUX_PKG_DESCRIPTION="Multi-protocol instant messaging client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=2.13.0
TERMUX_PKG_REVISION=13
TERMUX_PKG_SRCURL=https://bitbucket.org/pidgin/main/downloads/pidgin-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=2747150c6f711146bddd333c496870bfd55058bab22ffb7e4eb784018ec46d8f
TERMUX_PKG_DEPENDS="gtk2, libgnutls, libidn, libsm, libxext, libxss"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-gstreamer
--disable-gtkspell
--disable-vv
--disable-meanwhile
--disable-avahi
--disable-dbus
--disable-perl
--disable-tcl
--disable-tk
"

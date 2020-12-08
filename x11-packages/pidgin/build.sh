TERMUX_PKG_HOMEPAGE=https://pidgin.im/
TERMUX_PKG_DESCRIPTION="Multi-protocol instant messaging client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=2.14.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/pidgin/files/Pidgin/${TERMUX_PKG_VERSION}/pidgin-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=21f0b20fee1421cf25bdf5c592b8a92eed9ca48c5c1e85b1fba90d965eff8db0
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

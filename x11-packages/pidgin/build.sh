TERMUX_PKG_HOMEPAGE=https://pidgin.im/
TERMUX_PKG_DESCRIPTION="Multi-protocol instant messaging client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=2.14.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/pidgin/files/Pidgin/${TERMUX_PKG_VERSION}/pidgin-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=58652e692539d4d2cc775649f1d43dd08351607d8dc8fbab97a93629e01225c1
TERMUX_PKG_DEPENDS="gtk2, libgnutls, libidn, libsasl, libsm, libxext, libxss"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-gevolution
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

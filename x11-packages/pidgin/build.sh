TERMUX_PKG_HOMEPAGE=https://pidgin.im/
TERMUX_PKG_DESCRIPTION="Multi-protocol instant messaging client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.14.6
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/pidgin/files/Pidgin/${TERMUX_PKG_VERSION}/pidgin-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3bbeaf777da68efa6547bee9e15f7e863a23df255c55b625ef83d63819f8e457
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

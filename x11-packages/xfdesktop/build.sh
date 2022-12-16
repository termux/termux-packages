TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="A desktop manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=4.18
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfdesktop/${_MAJOR_VERSION}/xfdesktop-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=661783e7e6605459926d80bca46d25ce2197c221456457a863ea9d0252120d14
TERMUX_PKG_DEPENDS="exo, garcon, gdk-pixbuf, glib, gtk3, libcairo, libnotify, libwnck, libx11, libxfce4ui, libxfce4util, pango, thunar, xfconf"
TERMUX_PKG_RECOMMENDS="hicolor-icon-theme"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-notifications
"

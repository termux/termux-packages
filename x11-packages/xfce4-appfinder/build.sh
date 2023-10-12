TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/xfce4-appfinder/start
TERMUX_PKG_DESCRIPTION="Application launcher and finder"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.18.1"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfce4-appfinder/${TERMUX_PKG_VERSION%.*}/xfce4-appfinder-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=9854ea653981be544ad545850477716c4c92d0c43eb47b75f78534837c0893f9
TERMUX_PKG_DEPENDS="garcon, gdk-pixbuf, gtk3, libcairo, libxfce4ui, libxfce4util, xfconf"

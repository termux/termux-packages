TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/xfce4-appfinder/start
TERMUX_PKG_DESCRIPTION="Application launcher and finder"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.20.0"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfce4-appfinder/${TERMUX_PKG_VERSION%.*}/xfce4-appfinder-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=82ca82f77dc83e285db45438c2fe31df445148aa986ffebf2faabee4af9e7304
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="garcon, gdk-pixbuf, glib, gtk3, libcairo, libxfce4ui, libxfce4util, xfconf"
TERMUX_PKG_BUILD_DEPENDS="xfce4-dev-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
"

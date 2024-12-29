TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/xfce4-taskmanager/start
TERMUX_PKG_DESCRIPTION="Easy to use task manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.8"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-taskmanager/${TERMUX_PKG_VERSION%.*}/xfce4-taskmanager-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=14b9d68b8feb88a642a9885b8549efe7fc9e6c155f638003f2a4a58d9eb2baab
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libwnck, libx11, libxfce4ui, libxfce4util, libxmu, xfconf"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-static
--enable-libx11
--enable-wnck3
"

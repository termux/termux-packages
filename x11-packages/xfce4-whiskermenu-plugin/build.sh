TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-whiskermenu-plugin/start
TERMUX_PKG_DESCRIPTION="Alternate menu plugin for the Xfce desktop environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.10.1"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-whiskermenu-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-whiskermenu-plugin-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8b5a777a5d9df1f1c39b109ba8b2d045cb2cc02c41a9a297aa00dcb2a4520530
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="exo, garcon, gdk-pixbuf, glib, gtk3, gtk-layer-shell, libc++, libcairo, libxfce4ui, libxfce4util, xfce4-panel, xfconf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DENABLE_ACCOUNTS_SERVICE=false"

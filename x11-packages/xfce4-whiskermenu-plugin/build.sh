TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-whiskermenu-plugin/start
TERMUX_PKG_DESCRIPTION="Alternate menu plugin for the Xfce desktop environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.8.2"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-whiskermenu-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-whiskermenu-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=cbff8325999a20194e0bbce6f4d3d568ce06704d2b79acd9547d6c90aa083e70
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="exo, garcon, gdk-pixbuf, glib, gtk3, libc++, libcairo, libxfce4ui, libxfce4util, xfce4-panel"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DENABLE_ACCOUNTS_SERVICE=false -DENABLE_GTK_LAYER_SHELL=false"

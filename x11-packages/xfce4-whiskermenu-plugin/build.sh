TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-whiskermenu-plugin/start
TERMUX_PKG_DESCRIPTION="Alternate menu plugin for the Xfce desktop environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.8.4"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-whiskermenu-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-whiskermenu-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=ed918950e01dc97fe831e01c698b44247f1537992999b1262ab61c799272b3b7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="exo, garcon, gdk-pixbuf, glib, gtk3, gtk-layer-shell, libc++, libcairo, libxfce4ui, libxfce4util, xfce4-panel, xfconf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DENABLE_ACCOUNTS_SERVICE=false"

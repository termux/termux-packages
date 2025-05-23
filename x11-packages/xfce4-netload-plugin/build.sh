TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-netload-plugin/start
TERMUX_PKG_DESCRIPTION="network load monitor plugin for the Xfce4 panel"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="1.5.0"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-netload-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-netload-plugin-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a868be8f73e8396c2d61903d46646993c5130d16ded71ddb5da9088abf7cb7ba
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gtk3, libxfce4ui, libxfce4util, xfce4-panel"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=false
"

TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-calculator-plugin/start
TERMUX_PKG_DESCRIPTION="Simple command line based calculator for the Xfce panel"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.0"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-calculator-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-calculator-plugin-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=aaf3d7e9654ef6cf8ec442ad9e4316c481f9a6087a8e8949261140f5ae136aeb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gtk3, libxfce4ui, libxfce4util, xfce4-panel"
TERMUX_PKG_BUILD_DEPENDS="xfce4-dev-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=false
"

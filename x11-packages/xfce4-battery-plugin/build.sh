TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-battery-plugin/start
TERMUX_PKG_DESCRIPTION="A battery monitor plugin for the Xfce panel"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-battery-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-battery-plugin-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1dba8f470d2b12517e7b86d83cd2ebf13eb57ff1a01a4f2d2d156cf5194d97b6
TERMUX_PKG_DEPENDS="glib, gtk3, termux-api, libxfce4ui, libxfce4util, xfce4-panel"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	cp -f $TERMUX_PKG_BUILDER_DIR/libacpi.c $TERMUX_PKG_SRCDIR/panel-plugin/
}

TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-battery-plugin/start
TERMUX_PKG_DESCRIPTION="A battery monitor plugin for the Xfce panel"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.5
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-battery-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-battery-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=752233bfb320ee1e26104a656cbb868299f562733063e2b9a18f0966585ce213
TERMUX_PKG_DEPENDS="termux-api, xfce4-panel"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	cp -f $TERMUX_PKG_BUILDER_DIR/libacpi.c $TERMUX_PKG_SRCDIR/panel-plugin/
}

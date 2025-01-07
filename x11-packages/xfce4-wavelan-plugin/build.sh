TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-wavelan-plugin/start
TERMUX_PKG_DESCRIPTION="wavelan status plugin for the Xfce4 panel"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="0.6.4"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-wavelan-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-wavelan-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=129c917b40ffa10d96f3d2c0d03f1e8ad8037c79133e9a6436661e37dd7bb3de
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libxfce4ui, libxfce4util, pango, xfce4-panel, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-static
"

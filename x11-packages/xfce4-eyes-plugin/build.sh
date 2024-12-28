TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-eyes-plugin/start
TERMUX_PKG_DESCRIPTION="This plugin adds eyes to the Xfce panel which follow your cursor, similar to the xeyes program."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="4.6.2"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-eyes-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-eyes-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=02b4ac637604a0b9262616cb9613e0fe6797fb6b0f1fc2889a77e1e0ad4a01a5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libxfce4ui, libxfce4util, pango, xfce4-panel, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-static
"

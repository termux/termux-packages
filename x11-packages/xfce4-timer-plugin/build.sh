TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-timer-plugin/start
TERMUX_PKG_DESCRIPTION="alarm and timer module for Xfce panel"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="1.7.3"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-timer-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-timer-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=acf4c861af88608b9e802a76a4b05846bd30189e0085e826680cc179b6df4cd3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libxfce4ui, libxfce4util, pango, xfce4-panel, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-static
"

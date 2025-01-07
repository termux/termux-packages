TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-netload-plugin/start
TERMUX_PKG_DESCRIPTION="network load monitor plugin for the Xfce4 panel"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="1.4.2"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-netload-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-netload-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=a2041338408b2670f8debe57fcec6af539f704659eba853943c1524936ebabeb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libxfce4ui, libxfce4util, pango, xfce4-panel, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-static
"

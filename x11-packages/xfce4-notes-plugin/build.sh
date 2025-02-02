TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-notes-plugin/start
TERMUX_PKG_DESCRIPTION="Notes application for the Xfce4 desktop"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="1.11.2"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-notes-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-notes-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=8301fcd397bbc98a3def3d94f04de30cc128b4a35477024d2bcb2952a161a3b5
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, gtksourceview4, harfbuzz, libcairo, libxfce4ui, libxfce4util, pango, xfce4-panel, xfconf, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-static
"

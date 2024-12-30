TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-notes-plugin/start
TERMUX_PKG_DESCRIPTION="Notes application for the Xfce4 desktop"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="1.11.1"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-notes-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-notes-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=ef410999c9dafc5cf13fdcfd62ae49728508c0d37510f006971d5291061524aa
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, gtksourceview4, harfbuzz, libcairo, libxfce4ui, libxfce4util, pango, xfce4-panel, xfconf, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-static
"

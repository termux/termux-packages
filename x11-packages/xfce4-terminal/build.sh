TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/terminal/start
TERMUX_PKG_DESCRIPTION="Terminal Emulator for the XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.1"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-terminal/${TERMUX_PKG_VERSION%.*}/xfce4-terminal-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=5ab5c9b49c00be29f0be4eee5ccfa5073b16f2456185270265a9324549080aa6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libvte, libx11, libxfce4ui, libxfce4util, pango, xfconf"
TERMUX_PKG_RECOMMENDS="desktop-file-utils, hicolor-icon-theme"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk-doc-html=no"

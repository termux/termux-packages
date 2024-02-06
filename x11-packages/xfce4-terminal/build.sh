TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/terminal/start
TERMUX_PKG_DESCRIPTION="Terminal Emulator for the XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.2"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-terminal/${TERMUX_PKG_VERSION%.*}/xfce4-terminal-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=79a85ee216502c7248e04d560adf8fef86b9d0e047f81e9ea4fe26fbda34d810
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libvte, libx11, libxfce4ui, libxfce4util, pango, xfconf"
TERMUX_PKG_RECOMMENDS="desktop-file-utils, hicolor-icon-theme"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk-doc-html=no"

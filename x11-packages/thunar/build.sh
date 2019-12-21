TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/thunar/start
TERMUX_PKG_DESCRIPTION="Modern file manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.8.11
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/thunar/${TERMUX_PKG_VERSION%.*}/thunar-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=18de4db3a40e8e75377fcb5f7d78efdae8659f6a454f1b9cf77bb5f083e1b238
TERMUX_PKG_DEPENDS="desktop-file-utils, exo, hicolor-icon-theme, libexif, libnotify, libpng, libxfce4ui, libxfce4util"

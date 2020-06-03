TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/thunar/start
TERMUX_PKG_DESCRIPTION="Modern file manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.8.15
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/thunar/${TERMUX_PKG_VERSION%.*}/thunar-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=7624560cf21f13869804947042610aab22075146b711593f11ceb9e494277c93
TERMUX_PKG_DEPENDS="desktop-file-utils, exo, hicolor-icon-theme, libexif, libnotify, libpng, libxfce4ui, libxfce4util"

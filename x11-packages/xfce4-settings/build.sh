TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Settings manager for XFCE environment"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=4.16.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://archive.xfce.org/src/xfce/xfce4-settings/${TERMUX_PKG_VERSION:0:4}/xfce4-settings-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=bb28e1be7aa34d0edb1cfbaacc509a4267db56828b36cd6be312a202973635c6
TERMUX_PKG_DEPENDS="exo, garcon, libnotify, libxfce4ui, libxklavier, lxde-icon-theme"

TERMUX_PKG_RM_AFTER_INSTALL="
share/icons/hicolor/icon-theme.cache
"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-xrandr
--enable-xcursor
--enable-libnotify
--enable-libxklavier
--enable-pluggable-dialogs
--enable-sound-settings
"

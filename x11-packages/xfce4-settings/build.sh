TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Settings manager for XFCE environment"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=4.15.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://archive.xfce.org/src/xfce/xfce4-settings/${TERMUX_PKG_VERSION:0:4}/xfce4-settings-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=2933aee1c08188cc2cc313431eeee99fc54392a08e1fa4ca783e46057f87900c
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

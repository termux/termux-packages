TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Settings manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=4.17
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.2
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfce4-settings/${_MAJOR_VERSION}/xfce4-settings-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=f47089ca5e8efc20b17900555a5cde7177af223995d85ef5211fa1074447388f
TERMUX_PKG_DEPENDS="atk, exo, fontconfig, garcon, gdk-pixbuf, glib, gtk3, libcairo, libnotify, libx11, libxcursor, libxfce4ui, libxfce4util, libxi, libxklavier, libxrandr, pango, xfconf"
TERMUX_PKG_RECOMMENDS="gsettings-desktop-schemas, libcanberra, lxde-icon-theme"
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

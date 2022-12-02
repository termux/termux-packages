TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Settings manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=4.17
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.3
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfce4-settings/${_MAJOR_VERSION}/xfce4-settings-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=8bc5905d2157186e0b9c01421df0b7cbb7e8618653b495810dd95e95888162e2
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

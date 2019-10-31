TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Settings manager for XFCE environment"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=4.14.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://archive.xfce.org/src/xfce/xfce4-settings/${TERMUX_PKG_VERSION:0:4}/xfce4-settings-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=e873e9f6b8e801fd9304ee100c4c76ed9987446c38429d02477c086431c0bf7a
TERMUX_PKG_DEPENDS="exo, garcon, libnotify, libxfce4ui, libxklavier, lxde-icon-theme"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-xrandr
--enable-xcursor
--enable-libnotify
--enable-libxklavier
--enable-pluggable-dialogs
--enable-sound-settings
"

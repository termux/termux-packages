TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Settings manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=4.16
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.3
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfce4-settings/${_MAJOR_VERSION}/xfce4-settings-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=f299e6d26d8e142c0b7edeb9b8917d6bd50bc8647254ea585069c68f2bab8e64
TERMUX_PKG_DEPENDS="exo, garcon, libnotify, libxfce4ui, libxklavier, lxde-icon-theme, libcanberra, gtk3, gsettings-desktop-schemas"
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

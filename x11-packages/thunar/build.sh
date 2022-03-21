TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/thunar/start
TERMUX_PKG_DESCRIPTION="Modern file manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.17.7
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/thunar/4.17/thunar-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=231d6245e627cc2f260ddd8574734607596db3acb69aac20be19d6f1ab8d4c03
TERMUX_PKG_DEPENDS="desktop-file-utils, exo, hicolor-icon-theme, libexif, libnotify, libpng, libxfce4ui, libxfce4util"
TERMUX_PKG_BUILD_DEPENDS="xfce4-panel"
TERMUX_PKG_RECOMMENDS="thunar-archive-plugin, tumbler"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk-doc-html=no --enable-introspection=no"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Panel for the XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.16.3
TERMUX_PKG_REVISION=17
TERMUX_PKG_SRCURL=http://archive.xfce.org/src/xfce/xfce4-panel/4.16/xfce4-panel-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=5934eaed8a76da52c29b734ccd79600255420333dd6ebd8fd9f066379af1e092
TERMUX_PKG_DEPENDS="desktop-file-utils, exo, hicolor-icon-theme, garcon, libwnck, libxfce4ui, xfconf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk-doc-html=no --enable-introspection=no --enable-vala=no --disable-dbusmenu-gtk3"

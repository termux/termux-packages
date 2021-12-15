TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/terminal/start
TERMUX_PKG_DESCRIPTION="Terminal Emulator for the XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.0
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-terminal/0.9/xfce4-terminal-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=53ba1f76501b3d85275c4749eb1d696ff5ef211c16af338f07e0dd6b7947e371
TERMUX_PKG_DEPENDS="desktop-file-utils, exo, hicolor-icon-theme, garcon, libxfce4ui, xfconf, libvte"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk-doc-html=no"

TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Panel for the XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
# Do not update: Termux doesn't have dbusmenu-gtk3-0.4 which is
# a required dependency.
TERMUX_PKG_VERSION=4.15.2
TERMUX_PKG_REVISION=14
TERMUX_PKG_SRCURL=http://archive.xfce.org/src/xfce/xfce4-panel/${TERMUX_PKG_VERSION:0:4}/xfce4-panel-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=a668b5315268ba5b14b6574edbe00c522f879dea659b75c7742da7140cc3657f
TERMUX_PKG_DEPENDS="desktop-file-utils, exo, hicolor-icon-theme, garcon, libwnck, libxfce4ui, xfconf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk3"

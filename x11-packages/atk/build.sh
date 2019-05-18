TERMUX_PKG_HOMEPAGE=https://www.gtk.org
TERMUX_PKG_DESCRIPTION="The interface definitions of accessibility infrastructure"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.32.0
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/gnome/sources/atk/${TERMUX_PKG_VERSION:0:4}/atk-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c3212e849fffe1f8099fe05e1f5e2d357a56458e5b288bfdceabdd5d6c814441

TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_CONFLICTS="libatk"
TERMUX_PKG_REPLACES="libatk"

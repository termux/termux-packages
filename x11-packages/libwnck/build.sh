TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libwnck
TERMUX_PKG_DESCRIPTION="Window Navigator Construction Kit"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=3.32.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://ftp.gnome.org/pub/gnome/sources/libwnck/${TERMUX_PKG_VERSION:0:4}/libwnck-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=9595835cf28d0fc6af5526a18f77f2fcf3ca8c09e36741bb33915b6e69b8e3ca
TERMUX_PKG_DEPENDS="gtk2, startup-notification"
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}

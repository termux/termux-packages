TERMUX_PKG_HOMEPAGE=http://www.xfce.org/
TERMUX_PKG_DESCRIPTION="The libxfce4ui package contains GTK+ 2 widgets that are used by other Xfce applications."
TERMUX_PKG_VERSION=4.14.1
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_SRCURL=http://archive.xfce.org/src/xfce/libxfce4ui/4.14/libxfce4ui-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=c449075eaeae4d1138d22eeed3d2ad7032b87fb8878eada9b770325bed87f2da
TERMUX_PKG_DEPENDS="xfconf, gtk2, gtk3, startup-notification, libice, libsm"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-gtk3
--with-vendor-info=Termux
"

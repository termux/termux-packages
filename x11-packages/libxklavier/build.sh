TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/LibXklavier/
TERMUX_PKG_DESCRIPTION="High-level API for X Keyboard Extension"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=5.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/libxklavier/${TERMUX_PKG_VERSION}/libxklavier-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ebec3bc54b5652838502b96223152fb1cd8fcb14ace5cb02d718fc3276bbd404
TERMUX_PKG_DEPENDS="glib, iso-codes, libxi, libxkbfile, libxml2, xkeyboard-config"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-xkb-base=$TERMUX_PREFIX/share/X11/xkb"

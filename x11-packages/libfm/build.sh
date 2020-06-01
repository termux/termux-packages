TERMUX_PKG_HOMEPAGE=https://lxde.org/
TERMUX_PKG_DESCRIPTION="Library for file management"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.3.1
TERMUX_PKG_REVISION=13
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/pcmanfm/libfm-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=96b1244bde41ca0eef0332cfb5c67bb16725dfd102128f3e6f74fadc13a1cfe4
TERMUX_PKG_DEPENDS="atk, glib, gtk3, libandroid-support, libcairo, libexif, libffi, libfm, menu-cache, pango, pcre"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-gtk=3"

TERMUX_PKG_CONFLICTS="libfm-extra"
TERMUX_PKG_REPLACES="libfm-extra"
TERMUX_PKG_PROVIDES="libfm-extra (= $TERMUX_PKG_VERSION)"

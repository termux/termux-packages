TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/pcmanfm/
TERMUX_PKG_DESCRIPTION="Library for file management"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.2
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/pcmanfm/libfm-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=a5042630304cf8e5d8cff9d565c6bd546f228b48c960153ed366a34e87cad1e5
TERMUX_PKG_DEPENDS="atk, glib, gtk3, libandroid-support, libcairo, libexif, libffi, menu-cache, pango, pcre"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-gtk=3"

TERMUX_PKG_CONFLICTS="libfm-extra"
TERMUX_PKG_REPLACES="libfm-extra"
TERMUX_PKG_PROVIDES="libfm-extra (= $TERMUX_PKG_VERSION)"

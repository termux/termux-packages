TERMUX_PKG_HOMEPAGE=https://www.gtk.org
TERMUX_PKG_DESCRIPTION="The interface definitions of accessibility infrastructure"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.34.1
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/gnome/sources/atk/${TERMUX_PKG_VERSION:0:4}/atk-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d4f0e3b3d21265fcf2bc371e117da51c42ede1a71f6db1c834e6976bb20997cb
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_CONFLICTS="libatk"
TERMUX_PKG_REPLACES="libatk"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dintrospection=false"

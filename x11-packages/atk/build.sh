TERMUX_PKG_HOMEPAGE=https://www.gtk.org
TERMUX_PKG_DESCRIPTION="The interface definitions of accessibility infrastructure"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=2.36.0
TERMUX_PKG_REVISION=10
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/gnome/sources/atk/${TERMUX_PKG_VERSION:0:4}/atk-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=fb76247e369402be23f1f5c65d38a9639c1164d934e40f6a9cf3c9e96b652788
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_CONFLICTS="libatk"
TERMUX_PKG_REPLACES="libatk"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dintrospection=false"

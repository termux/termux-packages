TERMUX_PKG_HOMEPAGE=https://keep.imfreedom.org/libgnt/libgnt
TERMUX_PKG_DESCRIPTION="An ncurses toolkit for creating text-mode graphical user interfaces in a fast and easy way"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.14.3
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/pidgin/libgnt/${TERMUX_PKG_VERSION}/libgnt-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=57f5457f72999d0bb1a139a37f2746ec1b5a02c094f2710a339d8bcea4236123
TERMUX_PKG_DEPENDS="glib, libxml2, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Ddoc=false -Dpython2=false"

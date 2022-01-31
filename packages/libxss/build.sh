# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Screen Saver extension library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.3
TERMUX_PKG_REVISION=13
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXScrnSaver-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=f917075a1b7b5a38d67a8b0238eaab14acd2557679835b154cf2bca576e89bf8
TERMUX_PKG_DEPENDS="libx11, libxau, libxcb, libxdmcp, libxext"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"

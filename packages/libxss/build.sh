# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Screen Saver extension library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.4"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXScrnSaver-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=75cd2859f38e207a090cac980d76bc71e9da99d48d09703584e00585abc920fe
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libx11, libxau, libxcb, libxdmcp, libxext"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"

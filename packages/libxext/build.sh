# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 miscellaneous extensions library"
# Licenses: MIT, HPND, ISC
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.6"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXext-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=edb59fa23994e405fdc5b400afdf5820ae6160b94f35e3dc3da4457a16e89753
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"
TERMUX_PKG_DEPENDS="libx11"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"

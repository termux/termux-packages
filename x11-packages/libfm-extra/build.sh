## This is stripped down version of 'libfm' package.
## Primarily used for compiling 'menu-cache'.

TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/pcmanfm/
TERMUX_PKG_DESCRIPTION="Extra library for file management"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.3.1
TERMUX_PKG_REVISION=18
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/pcmanfm/libfm-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=96b1244bde41ca0eef0332cfb5c67bb16725dfd102128f3e6f74fadc13a1cfe4
TERMUX_PKG_DEPENDS="glib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-extra-only
"

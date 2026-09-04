## This is a stripped down version of 'libfm' package.
## Primarily used for compiling 'menu-cache'.
TERMUX_PKG_HOMEPAGE=https://github.com/lxde/pcmanfm
TERMUX_PKG_DESCRIPTION="Extra library for file management"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.1
TERMUX_PKG_SRCURL="https://github.com/lxde/libfm/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a5042630304cf8e5d8cff9d565c6bd546f228b48c960153ed366a34e87cad1e5
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-extra-only"

TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/xorg/util/bdftopcf
TERMUX_PKG_DESCRIPTION="convert X font from Bitmap Distribution Format to Portable Compiled Format"
# License: HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.1
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/util/bdftopcf-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=11c953d53c0f3ed349d0198dfb0a40000b5121df7eef09f2615a262892fed908
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BUILD_DEPENDS="xorgproto"

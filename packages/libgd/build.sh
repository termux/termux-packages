TERMUX_PKG_HOMEPAGE=https://libgd.github.io/
TERMUX_PKG_DESCRIPTION="GD is an open source code library for the dynamic creation of images by programmers"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:2.3.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/libgd/libgd/releases/download/gd-${TERMUX_PKG_VERSION:2}/libgd-${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=dd3f1f0bb016edcc0b2d082e8229c822ad1d02223511997c80461481759b1ed2
TERMUX_PKG_DEPENDS="fontconfig, freetype, libheif, libiconv, libjpeg-turbo, libpng, libtiff, libwebp, zlib"
TERMUX_PKG_BREAKS="libgd-dev"
TERMUX_PKG_REPLACES="libgd-dev"

# Disable vpx support for now, look at https://github.com/gagern/libgd/commit/d41eb72cd4545c394578332e5c102dee69e02ee8
# for enabling:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-vpx --without-x"

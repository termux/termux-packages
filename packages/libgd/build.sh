TERMUX_PKG_HOMEPAGE=https://libgd.github.io/
TERMUX_PKG_DESCRIPTION="GD is an open source code library for the dynamic creation of images by programmers"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/libgd/libgd/releases/download/gd-${TERMUX_PKG_VERSION}/libgd-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=32590e361a1ea6c93915d2448ab0041792c11bae7b18ee812514fe08b2c6a342
TERMUX_PKG_DEPENDS="freetype, fontconfig, libiconv, libjpeg-turbo, libpng, libtiff, libwebp, zlib"
TERMUX_PKG_BREAKS="libgd-dev"
TERMUX_PKG_REPLACES="libgd-dev"

# Disable vpx support for now, look at https://github.com/gagern/libgd/commit/d41eb72cd4545c394578332e5c102dee69e02ee8
# for enabling:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-vpx --without-x"

TERMUX_PKG_HOMEPAGE=https://libgd.github.io/
TERMUX_PKG_DESCRIPTION="GD is an open source code library for the dynamic creation of images by programmers"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:2.3.2
TERMUX_PKG_SRCURL=https://github.com/libgd/libgd/releases/download/gd-${TERMUX_PKG_VERSION:2}/libgd-${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=ee0c74852c102140fc590541950127b63a3c6fa4592305c16738d23ed65f8ac3
TERMUX_PKG_DEPENDS="freetype, fontconfig, libiconv, libjpeg-turbo, libpng, libtiff, libwebp, zlib"
TERMUX_PKG_BREAKS="libgd-dev"
TERMUX_PKG_REPLACES="libgd-dev"

# Disable vpx support for now, look at https://github.com/gagern/libgd/commit/d41eb72cd4545c394578332e5c102dee69e02ee8
# for enabling:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-vpx --without-x"

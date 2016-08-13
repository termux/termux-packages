TERMUX_PKG_HOMEPAGE=http://libgd.org
TERMUX_PKG_DESCRIPTION="GD is an open source code library for the dynamic creation of images by programmers"
TERMUX_PKG_VERSION=2.2.3
TERMUX_PKG_SRCURL=https://github.com/libgd/libgd/releases/download/gd-${TERMUX_PKG_VERSION}/libgd-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="freetype, fontconfig, libjpeg-turbo, libpng, libtiff"
# Disable vpx support for now, look at https://github.com/gagern/libgd/commit/d41eb72cd4545c394578332e5c102dee69e02ee8
# for enabling:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-vpx"

TERMUX_PKG_HOMEPAGE=https://libgd.github.io/
TERMUX_PKG_DESCRIPTION="GD is an open source code library for the dynamic creation of images by programmers"
TERMUX_PKG_VERSION=2.2.4
TERMUX_PKG_SRCURL=https://github.com/libgd/libgd/releases/download/gd-${TERMUX_PKG_VERSION}/libgd-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=487a650aa614217ed08ab1bd1aa5d282f9d379cfd95c756aed0b43406381be65
TERMUX_PKG_DEPENDS="freetype, fontconfig, libjpeg-turbo, libpng, libtiff"
# Disable vpx support for now, look at https://github.com/gagern/libgd/commit/d41eb72cd4545c394578332e5c102dee69e02ee8
# for enabling:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-vpx --without-x"

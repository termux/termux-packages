TERMUX_PKG_HOMEPAGE=https://libgd.github.io/
TERMUX_PKG_DESCRIPTION="GD is an open source code library for the dynamic creation of images by programmers"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.1
TERMUX_PKG_SRCURL=https://github.com/libgd/libgd/releases/download/gd-${TERMUX_PKG_VERSION}/libgd-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e904a35fd3379ddb2d7c64f929b7cbdf0422863646dae252be0029b9e47c9fe3
TERMUX_PKG_DEPENDS="freetype, fontconfig, libiconv, libjpeg-turbo, libpng, libtiff, libwebp, zlib"
TERMUX_PKG_BREAKS="libgd-dev"
TERMUX_PKG_REPLACES="libgd-dev"

# Disable vpx support for now, look at https://github.com/gagern/libgd/commit/d41eb72cd4545c394578332e5c102dee69e02ee8
# for enabling:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-vpx --without-x"

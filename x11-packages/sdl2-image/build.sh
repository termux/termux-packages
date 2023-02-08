TERMUX_PKG_HOMEPAGE=https://github.com/libsdl-org/SDL_image
TERMUX_PKG_DESCRIPTION="A simple library to load images of various formats as SDL surfaces (version 2)"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.3
TERMUX_PKG_SRCURL=https://github.com/libsdl-org/SDL_image/releases/download/release-${TERMUX_PKG_VERSION}/SDL2_image-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=931c9be5bf1d7c8fae9b7dc157828b7eee874e23c7f24b44ba7eff6b4836312c
TERMUX_PKG_DEPENDS="libjpeg-turbo, libjxl, libpng, libtiff, libwebp, sdl2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-stb-image
--disable-jpg-shared
--disable-jxl-shared
--disable-png-shared
--disable-tif-shared
--disable-webp-shared
"

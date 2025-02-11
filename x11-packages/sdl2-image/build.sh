TERMUX_PKG_HOMEPAGE=https://github.com/libsdl-org/SDL_image
TERMUX_PKG_DESCRIPTION="A simple library to load images of various formats as SDL surfaces (version 2)"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.8.5"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/libsdl-org/SDL_image/releases/download/release-${TERMUX_PKG_VERSION}/SDL2_image-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8bc4c57f41e2c0db7f9b749b253ef6cecdc6f0b689ecbe36ee97b50115fff645
# Prevent updating to SDL3 version
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP='s/.*-//'
TERMUX_PKG_DEPENDS="libjpeg-turbo, libjxl, libpng, libtiff, libwebp, sdl2 | sdl2-compat"
TERMUX_PKG_ANTI_BUILD_DEPENDS="sdl2-compat"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-stb-image
--disable-jpg-shared
--disable-jxl-shared
--disable-png-shared
--disable-tif-shared
--disable-webp-shared
"

TERMUX_PKG_HOMEPAGE=https://github.com/libsdl-org/SDL_image
TERMUX_PKG_DESCRIPTION="A simple library to load images of various formats as SDL surfaces (version 2)"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.8.1"
TERMUX_PKG_SRCURL=https://github.com/libsdl-org/SDL_image/releases/download/release-${TERMUX_PKG_VERSION}/SDL2_image-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e4cab9a58c347a490c46723c17553b4e12233cd821d3b993a8475a50497f5a3e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP='s/.*-//'
TERMUX_PKG_DEPENDS="libjpeg-turbo, libjxl, libpng, libtiff, libwebp, sdl2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-stb-image
--disable-jpg-shared
--disable-jxl-shared
--disable-png-shared
--disable-tif-shared
--disable-webp-shared
"

TERMUX_PKG_HOMEPAGE=https://github.com/libsdl-org/SDL_image
TERMUX_PKG_DESCRIPTION="A simple library to load images of various formats as SDL surfaces (version 2)"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.8.10"
TERMUX_PKG_SRCURL="https://github.com/libsdl-org/SDL_image/releases/download/release-${TERMUX_PKG_VERSION}/SDL2_image-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=ebc059d01c007a62f4b04f10cf858527c875062532296943174df9a80264fd65
# Prevent updating to SDL3 version
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libavif, libjpeg-turbo, libjxl, libpng, libtiff, libwebp, sdl2 | sdl2-compat"
TERMUX_PKG_ANTI_BUILD_DEPENDS="sdl2-compat"
# "disable shared" in sdl2-image means "disable dynamic loading in favor of dynamic linking"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-stb-image
--disable-jpg-shared
--disable-jxl-shared
--disable-png-shared
--disable-tif-shared
--disable-webp-shared
--disable-avif-shared
"

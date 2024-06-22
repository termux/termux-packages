TERMUX_PKG_HOMEPAGE=https://github.com/libsdl-org/SDL_ttf
TERMUX_PKG_DESCRIPTION="A library that allows you to use TrueType fonts in your SDL applications (version 2)"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.22.0"
TERMUX_PKG_SRCURL=https://github.com/libsdl-org/SDL_ttf/releases/download/release-${TERMUX_PKG_VERSION}/SDL2_ttf-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d48cbd1ce475b9e178206bf3b72d56b66d84d44f64ac05803328396234d67723
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP='s/.*-//'
TERMUX_PKG_DEPENDS="freetype, opengl, sdl2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-freetype-builtin
--disable-harfbuzz
"

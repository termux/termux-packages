TERMUX_PKG_HOMEPAGE=https://github.com/libsdl-org/SDL_mixer
TERMUX_PKG_DESCRIPTION="A simple multi-channel audio mixer"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.8.2"
TERMUX_PKG_SRCURL="https://github.com/libsdl-org/SDL_mixer/releases/download/release-${TERMUX_PKG_VERSION}/SDL2_mixer-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=938dff531d00ace2296557a6599abe6f34599e2f34f0a4a08a397e2ccac8b8f7
TERMUX_PKG_DEPENDS="fluidsynth, libxmp, libflac, libmodplug, libvorbis, libmpg123, opusfile, sdl2 | sdl2-compat"
TERMUX_PKG_ANTI_BUILD_DEPENDS="sdl2-compat"
# Prevent updating to SDL3 version
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-music-mod-xmp
--disable-music-mod-modplug-shared
--disable-music-midi-fluidsynth-shared
--disable-music-ogg-stb
--enable-music-ogg-vorbis
--disable-music-ogg-vorbis-shared
--disable-music-flac-drflac
--enable-music-flac-libflac
--disable-music-flac-libflac-shared
--disable-music-mp3-drmp3
--enable-music-mp3-mpg123
--disable-music-mp3-mpg123-shared
--disable-music-opus-shared
"

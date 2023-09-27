TERMUX_PKG_HOMEPAGE=https://github.com/libsdl-org/SDL_mixer
TERMUX_PKG_DESCRIPTION="A simple multi-channel audio mixer"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.3
TERMUX_PKG_SRCURL=https://github.com/libsdl-org/SDL_mixer/releases/download/release-${TERMUX_PKG_VERSION}/SDL2_mixer-${TERMUX_PKG_VERSION}.tar.gz 
TERMUX_PKG_SHA256=7a6ba86a478648ce617e3a5e9277181bc67f7ce9876605eea6affd4a0d6eea8f
TERMUX_PKG_DEPENDS="fluidsynth, libflac, libmodplug, libvorbis, mpg123, opusfile, sdl2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
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

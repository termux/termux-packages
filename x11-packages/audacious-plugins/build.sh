TERMUX_PKG_HOMEPAGE=https://audacious-media-player.org
TERMUX_PKG_DESCRIPTION="Plugins for Audacious"
# "The plugins themselves are distributed under their own distribution terms."
# Licenses: GPL-2.0, LGPL-2.1, GPL-3.0, BSD 2-Clause, BSD 3-Clause, MIT, ISC
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.5.1"
TERMUX_PKG_SRCURL=https://distfiles.audacious-media-player.org/audacious-plugins-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=f4feedc32776acfa9d24701d3b794fc97822f76da6991e91e627e70e561fdd3b
TERMUX_PKG_DEPENDS="audacious, ffmpeg, fluidsynth, glib, libc++, libcue, libcurl, libflac, libmp3lame, libogg, libopenmpt, libsamplerate, libsndfile, libsoxr, libvorbis, libx11, libxml2, libmpg123, opusfile, pulseaudio, qt6-qtbase, qt6-qtmultimedia, sdl2 | sdl2-compat, zlib"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools"
TERMUX_PKG_ANTI_BUILD_DEPENDS="sdl2-compat"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-gtk --disable-wavpack --disable-qtglspectrum --disable-neon"

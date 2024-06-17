TERMUX_PKG_HOMEPAGE=https://audacious-media-player.org
TERMUX_PKG_DESCRIPTION="Plugins for Audacious"
# "The plugins themselves are distributed under their own distribution terms."
# Licenses: GPL-2.0, LGPL-2.1, GPL-3.0, BSD 2-Clause, BSD 3-Clause, MIT, ISC
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.4"
TERMUX_PKG_SRCURL=https://distfiles.audacious-media-player.org/audacious-plugins-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=3caf3a5fe5b6f2808f461f85132fbff4ae22a53ef9f3d26d9e6030f6c6d5baa2
TERMUX_PKG_DEPENDS="audacious, ffmpeg, fluidsynth, glib, libc++, libcue, libcurl, libflac, libmp3lame, libogg, libsamplerate, libsndfile, libsoxr, libvorbis, libx11, libxml2, mpg123, opusfile, pulseaudio, qt5-qtbase, qt5-qtmultimedia, qt5-qtx11extras, sdl2, zlib"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-qt5 --disable-gtk --disable-wavpack --disable-qtglspectrum --disable-neon"

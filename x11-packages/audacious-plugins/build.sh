TERMUX_PKG_HOMEPAGE=https://audacious-media-player.org
TERMUX_PKG_DESCRIPTION="Plugins for Audacious"
# "The plugins themselves are distributed under their own distribution terms."
# Licenses: GPL-2.0, LGPL-2.1, GPL-3.0, BSD 2-Clause, BSD 3-Clause, MIT, ISC
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=4.2
TERMUX_PKG_SRCURL=https://distfiles.audacious-media-player.org/audacious-plugins-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=6fa0f69c3a1041eb877c37109513ab4a2a0a56a77d9e8c13a1581cf1439a417f
TERMUX_PKG_DEPENDS="audacious, ffmpeg, fluidsynth, glib, libc++, libcue, libcurl, libflac, libmp3lame, libogg, libsndfile, libsoxr, libvorbis, libx11, libxml2, mpg123, pulseaudio, qt5-qtbase, qt5-qtmultimedia, qt5-qtx11extras, zlib"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-gtk --disable-wavpack --disable-qtglspectrum --disable-neon"

TERMUX_PKG_HOMEPAGE=https://audacious-media-player.org
TERMUX_PKG_DESCRIPTION="Plugins for Audacious"
# "The plugins themselves are distributed under their own distribution terms."
# Licenses: GPL-2.0, LGPL-2.1, GPL-3.0, BSD 2-Clause, BSD 3-Clause, MIT, ISC
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.6.1"
TERMUX_PKG_SRCURL="https://distfiles.audacious-media-player.org/audacious-plugins-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=22e58a8a2c3f3caa9687434353618c822963cc8846cd239de36d4e8e5bd166a6
TERMUX_PKG_DEPENDS="audacious, ffmpeg, fluidsynth, glib, libc++, libcue, libcurl, libflac, libmp3lame, libogg, libopenmpt, libsamplerate, libsndfile, libsoxr, libvorbis, libx11, libxml2, libmpg123, opusfile, pulseaudio, qt6-qtbase, qt6-qtmultimedia, sdl2 | sdl2-compat, zlib"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools"
TERMUX_PKG_ANTI_BUILD_DEPENDS="sdl2-compat"
TERMUX_PKG_AUTO_UPDATE=true
# Enable Qt6, disable Qt5 and all GTK
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtk=false
-Dgtk2=false
-Dqt=true
-Dqt5=false
-Dgtkui=false
-Dqtui=true
-Dwavpack=false
-Dgl-spectrum=false
-Dneon=false
"

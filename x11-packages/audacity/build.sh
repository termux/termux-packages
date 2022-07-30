TERMUX_PKG_HOMEPAGE=https://www.audacityteam.org/
TERMUX_PKG_DESCRIPTION="An easy-to-use, multi-track audio editor and recorder"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Version 3.0.0 or higher does not work with vanilla wxWidgets.
TERMUX_PKG_VERSION=2.4.2
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/audacity/audacity/archive/Audacity-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cdb4800c8e9d1d4ca19964caf8d24000f80286ebd8a4db566c2622449744c099
TERMUX_PKG_DEPENDS="glib, gtk3, libc++, libexpat, libflac, libmp3lame, libogg, libsndfile, libsoxr, libvorbis, wxwidgets, zlib"
# FFmpeg 5.0 is not yet supported:
# https://github.com/audacity/audacity/issues/2445
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Daudacity_use_wxwidgets=system
-Daudacity_use_expat=system
-Daudacity_use_lame=system
-Daudacity_use_sndfile=system
-Daudacity_use_soxr=system
-Daudacity_use_portaudio=local
-Daudacity_use_ffmpeg=off
-Daudacity_use_id3tag=off
-Daudacity_use_mad=off
-Daudacity_use_nyquist=local
-Daudacity_use_vamp=off
-Daudacity_use_ogg=system
-Daudacity_use_vorbis=system
-Daudacity_use_flac=system
-Daudacity_use_lv2=off
-Daudacity_use_midi=off
-Daudacity_use_portmixer=local
-Daudacity_use_portsmf=off
-Daudacity_use_sbsms=off
-Daudacity_use_soundtouch=off
-Daudacity_use_twolame=off
"

termux_step_pre_configure() {
	CPPFLAGS+=" -Dushort=u_short -Dulong=u_long"
}

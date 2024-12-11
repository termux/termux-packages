TERMUX_PKG_HOMEPAGE=https://www.videolan.org/
TERMUX_PKG_DESCRIPTION="A popular libre and open source media player and multimedia engine"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.21"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://download.videolan.org/pub/videolan/vlc/${TERMUX_PKG_VERSION}/vlc-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=24dbbe1d7dfaeea0994d5def0bbde200177347136dbfe573f5b6a4cee25afbb0
TERMUX_PKG_DEPENDS="chromaprint, dbus, ffmpeg, fluidsynth, fontconfig, freetype, fribidi, glib, gst-plugins-base, gstreamer, harfbuzz, liba52, libandroid-shmem, libandroid-spawn, libaom, libarchive, libass, libbluray, libc++, libcaca, libcairo, libcddb, libdav1d, libdvbpsi, libdvdnav, libdvdread, libebml, libflac, libgcrypt, libgnutls, libgpg-error, libiconv, libidn, libjpeg-turbo, liblua52, libmad, libmatroska, libmpeg2, libnfs, libogg, libopus, libpng, librsvg, libsecret, libsoxr, libssh2, libtheora, libtwolame, libvorbis, libvpx, libx11, libx264, libx265, libxcb, libxml2, mpg123, ncurses, opengl, pulseaudio, samba, taglib, zlib"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
--disable-live555
--disable-dc1394
--disable-dv1394
--disable-linsys
--disable-opencv
--disable-dsm
--disable-v4l2
--disable-decklink
--disable-vnc
--disable-freerdp
--disable-asdcp
--disable-gme
--disable-sid
--disable-shout
--disable-mod
--disable-mpc
--disable-shine
--disable-crystalhd
--disable-libva
--disable-dxva2
--disable-d3d11va
--disable-faad
--disable-dca
--disable-speex
--disable-spatialaudio
--disable-schroedinger
--disable-mfx
--disable-fluidlite
--disable-zvbi
--disable-aribsub
--disable-aribb25
--disable-kate
--disable-tiger
--disable-vdpau
--disable-sdl-image
--disable-kva
--disable-mmal
--disable-alsa
--disable-oss
--disable-sndio
--disable-wasapi
--disable-jack
--disable-samplerate
--disable-kai
--disable-chromecast
--disable-qt
--disable-skins2
--disable-srt
--disable-goom
--disable-projectm
--disable-vsxu
--disable-avahi
--disable-udev
--disable-mtp
--disable-upnp
--disable-microdns
--disable-notify
--disable-libplacebo
ac_cv_func_ffsll=yes
ac_cv_func_swab=yes
ac_cv_prog_LUAC=luac5.2
"

termux_step_pre_configure() {
	autoreconf -fi

	CFLAGS+=" -fcommon"
	LDFLAGS+=" -landroid-shmem -landroid-spawn -lm"
	LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib/vlc"

	local _libgcc="$($CC -print-libgcc-file-name)"
	LDFLAGS+=" -L$(dirname $_libgcc) -l:$(basename $_libgcc)"
}

termux_step_post_configure() {
	# Avoid overlinking
	sed -i 's/ -shared / -Wl,--as-needed\0/g' ./libtool
}

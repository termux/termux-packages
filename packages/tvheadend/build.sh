TERMUX_PKG_HOMEPAGE="https://tvheadend.org/"
TERMUX_PKG_DESCRIPTION="TV streaming server for Linux and Android supporting DVB-S, DVB-S2 and other formats."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@MrAdityaAlok <dev.aditya.alok@gmail.com>"
TERMUX_PKG_VERSION=4.2.8
TERMUX_PKG_SRCURL="https://github.com/tvheadend/tvheadend/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=1aef889373d5fad2a7bd2f139156d4d5e34a64b6d38b87b868a2df415f01f7ad
TERMUX_PKG_DEPENDS="openssl, libiconv, zlib, ffmpeg, pcre2, libopus, libdvbcsa, libx264, libx265, libvpx, libfdk-aac, libogg, libtheora, libvorbis, pngquant"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-android
--nowerror
--enable-pcre
--enable-zlib
--enable-pngquant
--enable-ffmpeg
--enable-libx264
--enable-libx265
--enable-libvpx
--enable-libogg
--enable-libtheora
--enable-libvorbis
--enable-libfdkaac
--enable-libopus
--disable-libav
--enable-tvhcsa
--disable-hdhomerun_static
--disable-ffmpeg_static
--disable-avahi
"

termux_step_pre_configure() {
	termux_setup_cmake

	CFLAGS+=" -I${TERMUX_PREFIX}/include"

	# Arm (or Android ?) does not support mmx and sse2 instructions.
	if [ "${TERMUX_ARCH}" = "arm" ] || [ "${TERMUX_ARCH}" = "aarch64" ]; then
		patch -p1 <"${TERMUX_PKG_BUILDER_DIR}/disable-mmx-sse2"
	fi
}

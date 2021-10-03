TERMUX_PKG_HOMEPAGE="https://tvheadend.org/"
TERMUX_PKG_DESCRIPTION="TV streaming server for Linux and Android supporting DVB-S, DVB-S2 and other formats."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@MrAdityaAlok <dev.aditya.alok@gmail.com>"
TERMUX_PKG_VERSION=4.2.8
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/tvheadend/tvheadend/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=1aef889373d5fad2a7bd2f139156d4d5e34a64b6d38b87b868a2df415f01f7ad
TERMUX_PKG_DEPENDS="libiconv, ffmpeg, libopus, libx264, libx265, libvpx, libfdk-aac, libogg, libtheora, libvorbis, pngquant"
TERMUX_PKG_BUILD_DEPENDS="gettext, openssl, zlib, libdvbcsa, pcre2, dbus"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-android
--enable-pngquant
--enable-dvbcsa
--disable-libav
--disable-hdhomerun_static
--disable-ffmpeg_static
--disable-avahi
"

termux_step_pre_configure() {
	termux_setup_cmake

	CFLAGS+=" -I${TERMUX_PREFIX}/include"

	# Arm does not support mmx and sse2 instructions, still checks return true
	if [ "${TERMUX_ARCH}" = "arm" ] || [ "${TERMUX_ARCH}" = "aarch64" ]; then
		patch -p1 <"${TERMUX_PKG_BUILDER_DIR}/disable-mmx-sse2"
	fi
}

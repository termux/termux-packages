TERMUX_PKG_HOMEPAGE=https://mpv.io/
TERMUX_PKG_DESCRIPTION="Command-line media player"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
# Update both mpv and mpv-x to the same version in one PR.
TERMUX_PKG_VERSION="0.39.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/mpv-player/mpv/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2ca92437affb62c2b559b4419ea4785c70d023590500e8a52e95ea3ab4554683
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="alsa-lib, ffmpeg, jack, libandroid-glob, libandroid-support, libarchive, libass, libcaca, libiconv, liblua52, libsixel, libuchardet, openal-soft, pulseaudio, rubberband, zlib, libplacebo"
TERMUX_PKG_RM_AFTER_INSTALL="share/icons share/applications"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlibmpv=true
-Dlua=lua52
-Ddvdnav=disabled
-Dlcms2=disabled
-Dlibbluray=disabled
-Dvapoursynth=disabled
-Dzimg=disabled
-Dopenal=enabled
-Ddrm=disabled
-Dgbm=disabled
-Dgl=disabled
-Djpeg=disabled
-Dvdpau=disabled
-Dvaapi=disabled
-Dvulkan=disabled
-Dwayland=disabled
-Dx11=disabled
-Dxv=disabled
-Dandroid-media-ndk=disabled
"

termux_step_post_get_source() {
	# Version guard
	local ver_m=${TERMUX_PKG_VERSION#*:}
	local ver_x=$(. $TERMUX_SCRIPTDIR/x11-packages/mpv-x/build.sh; echo ${TERMUX_PKG_VERSION#*:})
	if [ "${ver_m}" != "${ver_x}" ]; then
		termux_error_exit "Version mismatch between mpv and mpv-x."
	fi
}

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
	sed -i "s/host_machine.system() == 'android'/false/" ${TERMUX_PKG_SRCDIR}/meson.build
}

termux_step_post_make_install() {
	# Use opensles audio out by default:
	install -Dm600 -t $TERMUX_PREFIX/etc/mpv/ $TERMUX_PKG_BUILDER_DIR/mpv.conf
	install -Dm600 -t $TERMUX_PREFIX/share/mpv/scripts/ $TERMUX_PKG_SRCDIR/TOOLS/lua/*
}

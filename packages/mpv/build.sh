TERMUX_PKG_HOMEPAGE=https://mpv.io/
TERMUX_PKG_DESCRIPTION="Command-line media player"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Update both mpv and mpv-x to the same version in one PR.
TERMUX_PKG_VERSION=0.35.1
TERMUX_PKG_SRCURL=https://github.com/mpv-player/mpv/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=41df981b7b84e33a2ef4478aaf81d6f4f5c8b9cd2c0d337ac142fc20b387d1a9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ffmpeg, libandroid-glob, libandroid-support, libarchive, libass, libcaca, libiconv, liblua52, libsixel, libuchardet, openal-soft, pulseaudio, rubberband, zlib"
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
}

termux_step_post_make_install() {
	# Use opensles audio out by default:
	install -Dm600 -t $TERMUX_PREFIX/etc/mpv/ $TERMUX_PKG_BUILDER_DIR/mpv.conf
	install -Dm600 -t $TERMUX_PREFIX/share/mpv/scripts/ $TERMUX_PKG_SRCDIR/TOOLS/lua/*
}

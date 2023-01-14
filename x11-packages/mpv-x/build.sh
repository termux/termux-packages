TERMUX_PKG_HOMEPAGE=https://mpv.io/
TERMUX_PKG_DESCRIPTION="Command-line media player"
# License: GPL-2.0-or-later
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Update both mpv and mpv-x to the same version in one PR.
TERMUX_PKG_VERSION=0.35.0
TERMUX_PKG_SRCURL=https://github.com/mpv-player/mpv/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dc411c899a64548250c142bf1fa1aa7528f1b4398a24c86b816093999049ec00
TERMUX_PKG_DEPENDS="ffmpeg, libandroid-glob, libandroid-shmem, libarchive, libass, libbluray, libcaca, libdrm, libdvdnav, libiconv, libjpeg-turbo, liblua52, libsixel, libuchardet, libx11, libxext, libxinerama, libxpresent, libxrandr, libxss, libzimg, littlecms, openal-soft, pulseaudio, rubberband, zlib"
TERMUX_PKG_CONFLICTS="mpv"
TERMUX_PKG_REPLACES="mpv"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlibmpv=true
-Dlua=lua52
-Ddvdnav=enabled
-Dvapoursynth=disabled
-Dopenal=enabled
-Dgbm=disabled
-Dgl=disabled
-Dvdpau=disabled
-Dvaapi=disabled
-Dvulkan=disabled
-Dwayland=disabled
-Dxv=disabled
-Dandroid-media-ndk=disabled
"

termux_step_post_get_source() {
	# Version guard
	local ver_m=$(. $TERMUX_SCRIPTDIR/packages/mpv/build.sh; echo ${TERMUX_PKG_VERSION#*:})
	local ver_x=${TERMUX_PKG_VERSION#*:}
	if [ "${ver_m}" != "${ver_x}" ]; then
		termux_error_exit "Version mismatch between mpv and mpv-x."
	fi
}

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -landroid-shmem"
}

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/etc/mpv/ $TERMUX_PKG_BUILDER_DIR/mpv.conf
	install -Dm600 -t $TERMUX_PREFIX/share/mpv/scripts/ $TERMUX_PKG_SRCDIR/TOOLS/lua/*
}

TERMUX_PKG_HOMEPAGE=https://mpv.io/
TERMUX_PKG_DESCRIPTION="Command-line media player"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
# Update both mpv and mpv-x to the same version in one PR.
TERMUX_PKG_VERSION="0.40.0"
TERMUX_PKG_SRCURL=https://github.com/mpv-player/mpv/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=10a0f4654f62140a6dd4d380dcf0bbdbdcf6e697556863dc499c296182f081a3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_AUTO_UPDATE_GROUP=x11/mpv
TERMUX_PKG_ALIGN_VERSION_WITH=mpv
TERMUX_PKG_DEPENDS="alsa-lib, ffmpeg, jack, libandroid-glob, libandroid-shmem, libarchive, libass, libbluray, libcaca, libdrm, libdvdnav, libiconv, libjpeg-turbo, liblua52, libsixel, libuchardet, libx11, libxext, libxinerama, libxpresent, libxrandr, libxss, libzimg, littlecms, openal-soft, pipewire, pulseaudio, rubberband, zlib, libplacebo"
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
-Dxv=disabled
-Dandroid-media-ndk=disabled
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -landroid-shmem"
	sed -i "s/host_machine.system() == 'android'/false/" ${TERMUX_PKG_SRCDIR}/meson.build
}

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/etc/mpv/ $TERMUX_PKG_BUILDER_DIR/mpv.conf
	install -Dm600 -t $TERMUX_PREFIX/share/mpv/scripts/ $TERMUX_PKG_SRCDIR/TOOLS/lua/*
}

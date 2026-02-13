TERMUX_PKG_HOMEPAGE=https://mpv.io/
TERMUX_PKG_DESCRIPTION="Command-line media player"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
# Update both mpv and mpv-x to the same version in one PR.
TERMUX_PKG_VERSION="0.41.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/mpv-player/mpv/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ee21092a5ee427353392360929dc64645c54479aefdb5babc5cfbb5fad626209
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="alsa-lib, ffmpeg, jack, libandroid-glob, libandroid-shmem, libarchive, libass, libbluray, libcaca, libdrm, libdvdnav, libiconv, libjpeg-turbo, luajit, libplacebo, libsixel, libuchardet, libx11, libxext, libxinerama, libxpresent, libxrandr, libxss, libzimg, littlecms, openal-soft, opengl, pipewire, pulseaudio, rubberband, zlib"
TERMUX_PKG_CONFLICTS="mpv"
TERMUX_PKG_REPLACES="mpv"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlibmpv=true
-Dlua=luajit
-Ddvdnav=enabled
-Dvapoursynth=disabled
-Dopenal=enabled
-Dgbm=disabled
-Dgl-x11=enabled
-Dvdpau=disabled
-Dvaapi=disabled
-Dvulkan=disabled
-Dxv=disabled
-Dandroid-media-ndk=disabled
"

# shellcheck disable=SC2031
termux_step_post_get_source() {
	# Version guard
	local ver_m ver_x
	ver_m="$(. "$TERMUX_SCRIPTDIR/packages/mpv/build.sh"; echo "${TERMUX_PKG_VERSION#*:}")"
	ver_x="${TERMUX_PKG_VERSION#*:}"
	if [[ "${ver_m}" != "${ver_x}" ]]; then
		termux_error_exit "Version mismatch between mpv and mpv-x."
	fi
}

# shellcheck disable=SC2031
termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -landroid-shmem"
	sed -i "s/host_machine.system() == 'android'/false/" "${TERMUX_PKG_SRCDIR}/meson.build"
}

termux_step_post_make_install() {
	# Use opensles audio out by default:
	install -Dm600 -t "$TERMUX_PREFIX/etc/mpv/" "$TERMUX_PKG_BUILDER_DIR/mpv.conf"
	install -Dm600 -t "$TERMUX_PREFIX/share/mpv/scripts/" "$TERMUX_PKG_SRCDIR/TOOLS/lua"/*
}

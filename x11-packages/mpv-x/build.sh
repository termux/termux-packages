TERMUX_PKG_HOMEPAGE=https://mpv.io/
TERMUX_PKG_DESCRIPTION="Command-line media player"
# License: GPL-2.0-or-later
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.34.1
TERMUX_PKG_SRCURL=https://github.com/mpv-player/mpv/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=32ded8c13b6398310fa27767378193dc1db6d78b006b70dbcbd3123a1445e746
TERMUX_PKG_DEPENDS="ffmpeg, fftw, libandroid-glob, libandroid-shmem, libarchive, libass, libbluray, libcaca, libdrm, libdvdnav, libdvdread, libiconv, libjpeg-turbo, liblua52, libsamplerate, libsixel, libuchardet, libx11, libxext, libxinerama, libxrandr, libxss, libzimg, littlecms, openal-soft, pulseaudio, rubberband, zlib"
TERMUX_PKG_CONFLICTS="mpv"
TERMUX_PKG_REPLACES="mpv"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-libmpv-shared
--enable-lua
--enable-dvdnav
--disable-vapoursynth
--enable-openal
--disable-gbm
--disable-wayland
--disable-xv
--disable-vdpau
--disable-vaapi
--disable-gl
--disable-vulkan
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -landroid-shmem"
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR

	./bootstrap.py

	./waf configure \
		--prefix=$TERMUX_PREFIX \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS

	./waf -v install
	install -Dm600 -t $TERMUX_PREFIX/etc/mpv/ $TERMUX_PKG_BUILDER_DIR/mpv.conf
	install -Dm600 -t $TERMUX_PREFIX/share/mpv/scripts/ $TERMUX_PKG_SRCDIR/TOOLS/lua/*
}

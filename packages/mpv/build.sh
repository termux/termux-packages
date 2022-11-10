TERMUX_PKG_HOMEPAGE=https://mpv.io/
TERMUX_PKG_DESCRIPTION="Command-line media player"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.34.1
TERMUX_PKG_REVISION=9
TERMUX_PKG_SRCURL=https://github.com/mpv-player/mpv/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=32ded8c13b6398310fa27767378193dc1db6d78b006b70dbcbd3123a1445e746
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ffmpeg, fftw, libandroid-glob, libandroid-support, libarchive, libass, libcaca, libiconv, liblua52, libsamplerate, libsixel, libuchardet, openal-soft, pulseaudio, rubberband, zlib"
TERMUX_PKG_RM_AFTER_INSTALL="share/icons share/applications"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-libmpv-shared
--enable-lua
--disable-libbluray
--disable-dvdnav
--disable-zimg
--disable-lcms2
--disable-vapoursynth
--enable-openal
--disable-gbm
--disable-wayland
--disable-xv
--disable-vdpau
--disable-vaapi
--disable-jpeg
--disable-gl
--disable-vulkan
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR

	./bootstrap.py

	./waf configure \
		--prefix=$TERMUX_PREFIX \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS

	./waf -v install

	# Use opensles audio out be default:
	mkdir -p $TERMUX_PREFIX/etc/mpv
	cp $TERMUX_PKG_BUILDER_DIR/mpv.conf $TERMUX_PREFIX/etc/mpv/mpv.conf
}

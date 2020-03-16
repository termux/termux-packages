TERMUX_PKG_HOMEPAGE=https://mpv.io/
TERMUX_PKG_DESCRIPTION="Command-line media player"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.32.0
TERMUX_PKG_SRCURL=https://github.com/mpv-player/mpv/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9163f64832226d22e24bbc4874ebd6ac02372cd717bef15c28a0aa858c5fe592
TERMUX_PKG_DEPENDS="ffmpeg, libandroid-glob, libandroid-shmem, libarchive, libass, libdrm, littlecms, libjpeg-turbo, libcaca, liblua52, libx11, libxext, libxinerama, libxss, libxrandr, openal-soft, pulseaudio, zlib"
TERMUX_PKG_CONFLICTS="mpv"
TERMUX_PKG_REPLACES="mpv"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -landroid-shmem"
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR

	./bootstrap.py

	./waf configure \
		--prefix=$TERMUX_PREFIX \
		--disable-gl \
		--enable-jpeg \
		--enable-lcms2 \
		--enable-libarchive \
		--enable-libass \
		--enable-lua \
		--enable-pulse \
		--enable-openal \
		--enable-caca \
		--disable-alsa \
		--enable-x11 \
		--disable-wayland

	./waf -v install
	install -Dm600 -t $TERMUX_PREFIX/etc/mpv/ $TERMUX_PKG_BUILDER_DIR/mpv.conf
	install -Dm600 -t $TERMUX_PREFIX/share/mpv/scripts/ $TERMUX_PKG_SRCDIR/TOOLS/lua/*
}

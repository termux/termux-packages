TERMUX_PKG_HOMEPAGE=https://mpv.io/
TERMUX_PKG_DESCRIPTION="Command-line media player"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.30.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/mpv-player/mpv/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=33a1bcb7e74ff17f070e754c15c52228cf44f2cefbfd8f34886ae81df214ca35
TERMUX_PKG_DEPENDS="ffmpeg, libandroid-glob, libandroid-shmem, libarchive, libass, libdrm, littlecms, libjpeg-turbo, libcaca, liblua52, libx11, libxext, libxinerama, libxss, libxrandr, openal-soft, pulseaudio, zlib"
TERMUX_PKG_CONFLICTS="mpv"
TERMUX_PKG_REPLACES="mpv"
TERMUX_PKG_RM_AFTER_INSTALL="share/icons share/applications"

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

	./waf install

	# Use opensles audio out be default:
	mkdir -p $TERMUX_PREFIX/etc/mpv
	cp $TERMUX_PKG_BUILDER_DIR/mpv.conf $TERMUX_PREFIX/etc/mpv/mpv.conf

	install -m644 $TERMUX_PKG_SRCDIR/TOOLS/lua/* \
		-D -t $TERMUX_PREFIX/share/mpv/scripts
}

TERMUX_PKG_HOMEPAGE=https://mplayerhq.hu/
TERMUX_PKG_DESCRIPTION="The Movie Player"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://ftp-osl.osuosl.org/pub/gentoo/distfiles/MPlayer-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=82596ed558478d28248c7bc3828eb09e6948c099bbd76bb7ee745a0e3275b548
TERMUX_PKG_DEPENDS="ffmpeg, fontconfig, freetype, fribidi, libass, libbz2, libdvdread, libiconv, libjpeg-turbo, liblzo, libmp3lame, libogg, libpng, libvorbis, libx11, libx264, libxext, libxss, ncurses, xvidcore, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-ffmpeg_a
--disable-vidix
--disable-gl
"
TERMUX_PKG_EXTRA_MAKE_ARGS="INSTALLSTRIP="
TERMUX_PKG_BLACKLISTED_ARCHES="i686"

termux_step_post_get_source() {
	termux_download \
		"https://github.com/gentoo/gentoo/raw/a3045b07e451738d566af36b38e96dbf76d8659c/media-video/mplayer/files/ffmpeg44.patch" \
		$TERMUX_PKG_CACHEDIR/mplayer-ffmpeg44.patch \
		eb796b380f9ed9a6a68ee523493dce5f27fc57b8c0dea0d44a13752ec7411fcd
	cat $TERMUX_PKG_CACHEDIR/mplayer-ffmpeg44.patch | patch --silent -p1
	termux_download \
		"https://dev.gentoo.org/~aballier/distfiles/mplayer-1.4-ffmpeg5.patch.bz2" \
		$TERMUX_PKG_CACHEDIR/mplayer-1.4-ffmpeg5.patch.bz2 \
		3397eb50fe7265dc435f6df824cd6153440c14029c8a0be76056ae89733970db
	bzcat $TERMUX_PKG_CACHEDIR/mplayer-1.4-ffmpeg5.patch.bz2 | patch --silent -p1
}

termux_step_configure_autotools() {
	sh "$TERMUX_PKG_SRCDIR/configure" \
		--target=$TERMUX_HOST_PLATFORM \
		--prefix=$TERMUX_PREFIX \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

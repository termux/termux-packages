TERMUX_PKG_HOMEPAGE=https://mplayerhq.hu/
TERMUX_PKG_DESCRIPTION="The Movie Player"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5
TERMUX_PKG_SRCURL=https://ftp-osl.osuosl.org/pub/gentoo/distfiles/MPlayer-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=650cd55bb3cb44c9b39ce36dac488428559799c5f18d16d98edb2b7256cbbf85
TERMUX_PKG_DEPENDS="ffmpeg, fontconfig, freetype, fribidi, liba52, libass, libbluray, libdvdnav, libdvdread, libiconv, libjpeg-turbo, liblzo, libmad, libmp3lame, libogg, libpng, libtheora, libtwolame, libvorbis, libx11, libx264, libxext, libxss, mpg123, ncurses, openal-soft, pulseaudio, xvidcore, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-smb
--disable-ffmpeg_a
--disable-vidix
--disable-gl
--disable-dga2
--disable-dga1
--disable-xinerama
"
TERMUX_PKG_EXTRA_MAKE_ARGS="INSTALLSTRIP="
TERMUX_PKG_BLACKLISTED_ARCHES="i686"

termux_step_post_get_source() {
	local FFMPEG_BUILD_SH=$TERMUX_SCRIPTDIR/packages/ffmpeg/build.sh
	local FFMPEG_SRCURL=$(bash -c ". $FFMPEG_BUILD_SH; echo \$TERMUX_PKG_SRCURL")
	local FFMPEG_SHA256=$(bash -c ". $FFMPEG_BUILD_SH; echo \$TERMUX_PKG_SHA256")
	local FFMPEG_TARFILE=$TERMUX_PKG_CACHEDIR/$(basename $FFMPEG_SRCURL)
	termux_download $FFMPEG_SRCURL $FFMPEG_TARFILE $FFMPEG_SHA256
	rm -rf ffmpeg
	mkdir ffmpeg
	cd ffmpeg
	tar xf $FFMPEG_TARFILE --strip-components=1
}

termux_step_configure_autotools() {
	sh "$TERMUX_PKG_SRCDIR/configure" \
		--target=$TERMUX_HOST_PLATFORM \
		--prefix=$TERMUX_PREFIX \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

TERMUX_PKG_HOMEPAGE=https://www.audacityteam.org/
TERMUX_PKG_DESCRIPTION="An easy-to-use, multi-track audio editor and recorder"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Version 3.0.0 or higher does not work with vanilla wxWidgets.
TERMUX_PKG_VERSION=2.4.2
TERMUX_PKG_REVISION=5
_FFMPEG_VERSION=4.4.2
TERMUX_PKG_SRCURL=(https://github.com/audacity/audacity/archive/Audacity-${TERMUX_PKG_VERSION}.tar.gz
                   https://www.ffmpeg.org/releases/ffmpeg-${_FFMPEG_VERSION}.tar.xz)
TERMUX_PKG_SHA256=(cdb4800c8e9d1d4ca19964caf8d24000f80286ebd8a4db566c2622449744c099
                   af419a7f88adbc56c758ab19b4c708afbcae15ef09606b82b855291f6a6faa93)
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libc++, libexpat, libflac, libmp3lame, libogg, libsndfile, libsoxr, libvorbis, wxwidgets"
# Support for FFmpeg 5.0 is not backported:
# https://github.com/audacity/audacity/issues/2445
TERMUX_PKG_SUGGESTS="audacity-ffmpeg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Daudacity_use_wxwidgets=system
-Daudacity_use_expat=system
-Daudacity_use_lame=system
-Daudacity_use_sndfile=system
-Daudacity_use_soxr=system
-Daudacity_use_portaudio=local
-Daudacity_use_ffmpeg=loaded
-Daudacity_use_id3tag=off
-Daudacity_use_mad=off
-Daudacity_use_nyquist=local
-Daudacity_use_vamp=off
-Daudacity_use_ogg=system
-Daudacity_use_vorbis=system
-Daudacity_use_flac=system
-Daudacity_use_lv2=off
-Daudacity_use_midi=off
-Daudacity_use_portmixer=local
-Daudacity_use_portsmf=off
-Daudacity_use_sbsms=off
-Daudacity_use_soundtouch=off
-Daudacity_use_twolame=off
"
TERMUX_PKG_RM_AFTER_INSTALL="
opt/audacity/include
opt/audacity/lib/pkgconfig
opt/audacity/share
"

termux_step_pre_configure() {
	local _FFMPEG_PREFIX=${TERMUX_PREFIX}/opt/${TERMUX_PKG_NAME}
	LDFLAGS="-Wl,-rpath=${_FFMPEG_PREFIX}/lib ${LDFLAGS}"

	local _ARCH
	case ${TERMUX_ARCH} in
		arm ) _ARCH=armeabi-v7a ;;
		i686 ) _ARCH=x86 ;;
		* ) _ARCH=$TERMUX_ARCH ;;
	esac

	mkdir -p _ffmpeg-${_FFMPEG_VERSION}
	pushd _ffmpeg-${_FFMPEG_VERSION}
	$TERMUX_PKG_SRCDIR/ffmpeg-${_FFMPEG_VERSION}/configure \
		--prefix=${_FFMPEG_PREFIX} \
		--cc=${CC} \
		--pkg-config=false \
		--arch=${_ARCH} \
		--cross-prefix=llvm- \
		--enable-cross-compile \
		--target-os=android \
		--disable-version3 \
		--disable-static \
		--enable-shared \
		--disable-all \
		--disable-autodetect \
		--disable-doc \
		--enable-avcodec \
		--enable-avformat \
		--disable-asm
	make -j ${TERMUX_MAKE_PROCESSES}
	make install
	popd

	local lib
	for lib in libavcodec libavformat libavutil; do
		local pc=${TERMUX_PREFIX}/lib/pkgconfig/${lib}.pc
		if [ -e ${pc} ]; then
			mv ${pc}{,.tmp}
		fi
	done
	export PKG_CONFIG_PATH=${_FFMPEG_PREFIX}/lib/pkgconfig
	CPPFLAGS="-I${_FFMPEG_PREFIX}/include ${CPPFLAGS}"

	CPPFLAGS+=" -Dushort=u_short -Dulong=u_long"
}

termux_step_post_make_install() {
	unset PKG_CONFIG_PATH
	local lib
	for lib in libavcodec libavformat libavutil; do
		local pc=${TERMUX_PREFIX}/lib/pkgconfig/${lib}.pc
		if [ -e ${pc}.tmp ] && [ ! -e ${pc} ]; then
			mv ${pc}{.tmp,}
		fi
	done

	local _FFMPEG_DOCDIR=$TERMUX_PREFIX/share/doc/audacity-ffmpeg
	mkdir -p ${_FFMPEG_DOCDIR}
	ln -sfr ${TERMUX_PREFIX}/share/LICENSES/LGPL-2.1.txt \
		${_FFMPEG_DOCDIR}/LICENSE
}

termux_step_post_massage() {
	rm -rf lib/pkgconfig
}

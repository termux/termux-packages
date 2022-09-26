TERMUX_PKG_HOMEPAGE=http://spek.cc/
TERMUX_PKG_DESCRIPTION="An acoustic spectrum analyser"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.4
_FFMPEG_VERSION=4.4.2
TERMUX_PKG_SRCURL=(https://github.com/alexkay/spek/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
                   https://www.ffmpeg.org/releases/ffmpeg-${_FFMPEG_VERSION}.tar.xz)
TERMUX_PKG_SHA256=(1751246e958cff91fe30b01925a38bf8cbd9c6abbd0d24e5b21eaad3d054534b
                   af419a7f88adbc56c758ab19b4c708afbcae15ef09606b82b855291f6a6faa93)
# FFmpeg 5.0 is not yet supported:
# https://github.com/alexkay/spek/issues/218
TERMUX_PKG_DEPENDS="wxwidgets"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_path_WX_CONFIG_PATH=$TERMUX_PREFIX/bin/wx-config"
TERMUX_PKG_RM_AFTER_INSTALL="
opt/$TERMUX_PKG_NAME/include
opt/$TERMUX_PKG_NAME/lib/pkgconfig
opt/$TERMUX_PKG_NAME/share
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
		--enable-rdft \
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

	mkdir -p m4
	cp $TERMUX_PREFIX/share/aclocal/wxwin.m4 m4/
	NOCONFIGURE=1 sh autogen.sh
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
}

termux_step_post_massage() {
	rm -f lib/pkgconfig/libav{codec,format,util}.pc
}

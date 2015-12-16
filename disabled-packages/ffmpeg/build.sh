TERMUX_PKG_HOMEPAGE=https://www.ffmpeg.org/
TERMUX_PKG_DESCRIPTION="Tools and libraries to manipulate a wide range of multimedia formats and protocols"
TERMUX_PKG_VERSION=2.8.3
TERMUX_PKG_SRCURL=https://github.com/FFmpeg/FFmpeg/archive/n${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=FFmpeg-n$TERMUX_PKG_VERSION
# libbz2 is used by matroska decoder:
TERMUX_PKG_DEPENDS="openssl, libbz2, libx264, xvidcore, libvorbis, libfaac, liblzma"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="share/ffmpeg/examples"
TERMUX_PKG_CONFLICTS="libav"

termux_step_configure () {
	cd $TERMUX_PKG_BUILDDIR
	if [ $TERMUX_ARCH = "arm" ]; then
		_ARCH="armeabi-v7a"
	elif [ $TERMUX_ARCH = "i686" ]; then
		_ARCH="x86"
	else
		_ARCH=$TERMUX_ARCH
	fi
        # --disable-asm to prevent text relocations
	$TERMUX_PKG_SRCDIR/configure \
		--arch=${_ARCH} \
		--cross-prefix=${TERMUX_HOST_PLATFORM}- \
                --disable-asm \
		--disable-ffserver \
		--disable-static \
                --disable-symver \
		--enable-cross-compile \
		--enable-gpl \
		--enable-libfaac \
		--enable-libvorbis \
		--enable-libx264 \
		--enable-libxvid \
		--enable-nonfree \
		--enable-openssl \
		--enable-shared \
		--prefix=$TERMUX_PREFIX \
		--target-os=linux
}


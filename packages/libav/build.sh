TERMUX_PKG_HOMEPAGE=http://libav.org/
TERMUX_PKG_DESCRIPTION="Tools and libraries to manipulate a wide range of multimedia formats and protocols"
TERMUX_PKG_VERSION=11.6
TERMUX_PKG_BUILD_REVISION=4
TERMUX_PKG_SRCURL=http://libav.org/releases/libav-${TERMUX_PKG_VERSION}.tar.xz
# libbz2 is used by matroska decoder:
TERMUX_PKG_DEPENDS="openssl, libbz2, libx264, xvidcore, libvorbis, libfaac, libmp3lame"
TERMUX_PKG_CONFLICTS="ffmpeg"

termux_step_configure () {
	cd $TERMUX_PKG_BUILDDIR

	# Specify --disable-asm to prevent text relocations on i686,
	# see https://trac.ffmpeg.org/ticket/4928
	# For libav we do it also for arm and aarch64 since text
	# relocations happens there as well (while ffmpeg doesn't
	# create text relocations even with asm for those).
	local _EXTRA_CONFIGURE_FLAGS="--disable-asm"

	if [ $TERMUX_ARCH = "arm" ]; then
		_ARCH="armeabi-v7a"
	elif [ $TERMUX_ARCH = "i686" ]; then
		_ARCH="x86"
	elif [ $TERMUX_ARCH = "aarch64" -o $TERMUX_ARCH = "x86_64" ]; then
		_ARCH=$TERMUX_ARCH
	else
		echo "Unsupported arch $TERMUX_ARCH"
		exit 1
	fi

	$TERMUX_PKG_SRCDIR/configure \
		--arch=${_ARCH} \
		--cross-prefix=${TERMUX_HOST_PLATFORM}- \
		--disable-avdevice \
		--disable-avserver \
		--disable-static \
                --disable-symver \
		--enable-cross-compile \
		--enable-gpl \
		--enable-libmp3lame \
		--enable-libfaac \
		--enable-libvorbis \
		--enable-libx264 \
		--enable-libxvid \
		--enable-nonfree \
		--enable-openssl \
		--enable-shared \
		--prefix=$TERMUX_PREFIX \
		--target-os=linux \
		$_EXTRA_CONFIGURE_FLAGS
}


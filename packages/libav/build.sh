TERMUX_PKG_HOMEPAGE=http://libav.org/
TERMUX_PKG_DESCRIPTION="Tools and libraries to manipulate a wide range of multimedia formats and protocols"
TERMUX_PKG_VERSION=11.4
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://libav.org/releases/libav-${TERMUX_PKG_VERSION}.tar.xz
# libbz2 is used by matroska decoder:
TERMUX_PKG_DEPENDS="openssl, libbz2, libx264, xvidcore, libvorbis, libfaac"

termux_step_configure () {
	cd $TERMUX_PKG_BUILDDIR
	if [ $TERMUX_ARCH = "arm" ]; then
		_ARCH="armeabi-v7a"
	elif [ $TERMUX_ARCH = "i686" ]; then
		_ARCH="x86"
	else
		echo "Unsupported arch: $TERMUX_ARCH"
		exit 1
	fi
        # --disable-asm to prevent text relocations
	$TERMUX_PKG_SRCDIR/configure \
		--arch=${_ARCH} \
		--cross-prefix=${TERMUX_HOST_PLATFORM}- \
                --disable-asm \
		--disable-avdevice \
		--disable-avserver \
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


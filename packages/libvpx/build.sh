TERMUX_PKG_HOMEPAGE=http://www.webmproject.org/
TERMUX_PKG_DESCRIPTION="VP9 Codec SDK"
TERMUX_PKG_VERSION=1.5.0
TERMUX_PKG_SRCURL=https://github.com/webmproject/libvpx/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=libvpx-${TERMUX_PKG_VERSION}

termux_step_configure () {
	if [ $TERMUX_ARCH = "arm" ]; then
		_CONFIGURE_TARGET=armv7-android-gcc
	elif [ $TERMUX_ARCH = "i686" ]; then
		export AS=yasm
		export LD=$CC
		_CONFIGURE_TARGET=x86-android-gcc
	else
		echo "Unsupported arch: $TERMUX_ARCH"
		exit 1
	fi
	$TERMUX_PKG_SRCDIR/configure \
		--sdk-path=$NDK \
		--target=$_CONFIGURE_TARGET \
		--prefix=$TERMUX_PREFIX \
		--disable-examples \
		--disable-vp8 \
		--enable-shared \
		--enable-small
}

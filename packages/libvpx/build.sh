TERMUX_PKG_HOMEPAGE=https://www.webmproject.org
TERMUX_PKG_DESCRIPTION="VP8 & VP9 Codec SDK"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.10.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/webmproject/libvpx/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=85803ccbdbdd7a3b03d930187cb055f1353596969c1f92ebec2db839fa4f834a
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="libvpx-dev"
TERMUX_PKG_REPLACES="libvpx-dev"

termux_step_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	# Force fresh install of header files:
	rm -Rf $TERMUX_PREFIX/include/vpx

	export LD=$CC

	if [ $TERMUX_ARCH = "arm" ]; then
		export AS=$TERMUX_HOST_PLATFORM-as
		_CONFIGURE_TARGET="--target=armv7-android-gcc"
	elif [ $TERMUX_ARCH = "i686" ]; then
		export AS=yasm
		_CONFIGURE_TARGET="--target=x86-android-gcc"
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		_CONFIGURE_TARGET="--force-target=arm64-v8a-android-gcc"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		export AS=yasm
		_CONFIGURE_TARGET="--target=x86_64-android-gcc"
	else
		termux_error_exit "Unsupported arch: $TERMUX_ARCH"
	fi

	# For --disable-realtime-only, see
	# https://bugs.chromium.org/p/webm/issues/detail?id=800
	# "The issue is that on android we soft enable realtime only.
	#  [..] You can enable non-realtime by setting --disable-realtime-only"
	# Discovered in https://github.com/termux/termux-packages/issues/554
	#CROSS=${TERMUX_HOST_PLATFORM}- CC=clang CXX=clang++ $TERMUX_PKG_SRCDIR/configure \
	$TERMUX_PKG_SRCDIR/configure \
		$_CONFIGURE_TARGET \
		--prefix=$TERMUX_PREFIX \
		--disable-examples \
		--disable-realtime-only \
		--disable-unit-tests \
		--enable-pic \
		--enable-vp8 \
		--enable-shared \
		--enable-small \
		--extra-cflags="-fPIC"
}

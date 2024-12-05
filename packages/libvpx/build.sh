TERMUX_PKG_HOMEPAGE=https://www.webmproject.org
TERMUX_PKG_DESCRIPTION="VP8 & VP9 Codec SDK"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:1.15.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/webmproject/libvpx/archive/v${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=e935eded7d81631a538bfae703fd1e293aad1c7fd3407ba00440c95105d2011e
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="libvpx-dev"
TERMUX_PKG_REPLACES="libvpx-dev"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"

termux_pkg_auto_update() {
	# Get the newest tag:
	local tag
	tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}" "${TERMUX_PKG_UPDATE_TAG_TYPE}")"
	# check if this is not a release (e.g. a release candidate):
	if grep -qP "^${TERMUX_PKG_UPDATE_VERSION_REGEXP}\$" <<<"$tag"; then
		termux_pkg_upgrade_version "$tag"
	else
		echo "WARNING: Skipping auto-update: Not a release($tag)"
	fi
}

termux_step_post_get_source() {
	# Check whether it is ABI compatible with previous version
	# Should revbump ffmpeg if ABI is changed
	local abi=9
	local encabi=36
	local decabi=12

	mkdir -p termux-abi-test && cd termux-abi-test
	gcc "$TERMUX_PKG_BUILDER_DIR"/abi-test.c -o abi-test -I../
	local abi_got eabi_got dabi_got
	IFS=' ' read -r abi_got eabi_got dabi_got < <(./abi-test)
	if [ "$abi_got $eabi_got $dabi_got" != "$abi $encabi $decabi" ]; then
		termux_error_exit "ABI version mismatch in libvpx, got $abi_got $eabi_got $dabi_got."
	fi
	cd -
	rm -rf termux-abi-test
}

termux_step_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	# Force fresh install of header files:
	rm -Rf $TERMUX_PREFIX/include/vpx

	if [ $TERMUX_ARCH = "arm" ]; then
		_CONFIGURE_TARGET="--target=armv7-android-gcc --disable-neon-asm"
	elif [ $TERMUX_ARCH = "i686" ]; then
		_CONFIGURE_TARGET="--target=x86-android-gcc"
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		_CONFIGURE_TARGET="--force-target=arm64-v8a-android-gcc"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
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
		--enable-postproc \
		--enable-vp8 \
		--enable-vp9 \
		--enable-vp9-highbitdepth \
		--enable-vp9-temporal-denoising \
		--enable-vp9-postproc \
		--enable-shared \
		--enable-small \
		--as=auto \
		--extra-cflags="-fPIC"
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="lib/libvpx.so.9"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "Error: file ${f} not found; please check if SOVERSION has changed."
		fi
	done
}

TERMUX_PKG_HOMEPAGE=https://ffmpeg.org
TERMUX_PKG_DESCRIPTION="Tools and libraries to manipulate a wide range of multimedia formats and protocols"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.1.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://www.ffmpeg.org/releases/ffmpeg-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=619e706d662c8420859832ddc259cd4d4096a48a2ce1eefd052db9e440eef3dc
TERMUX_PKG_DEPENDS="freetype, game-music-emu, libaom, libandroid-glob, libass, libbluray, libbz2, libdav1d, libgnutls, libiconv, liblzma, libmp3lame, libopus, librav1e, libsoxr, libtheora, libvorbis, libvpx, libvidstab, libwebp, libx264, libx265, libxml2, littlecms, ocl-icd, xvidcore, zlib"
TERMUX_PKG_BUILD_DEPENDS="opencl-headers"
TERMUX_PKG_CONFLICTS="libav"
TERMUX_PKG_BREAKS="ffmpeg-dev"
TERMUX_PKG_REPLACES="ffmpeg-dev"


termux_step_configure() {
	cd $TERMUX_PKG_BUILDDIR

	local _EXTRA_CONFIGURE_FLAGS=""
	if [ $TERMUX_ARCH = "arm" ]; then
		_ARCH="armeabi-v7a"
		_EXTRA_CONFIGURE_FLAGS="--enable-neon"
	elif [ $TERMUX_ARCH = "i686" ]; then
		_ARCH="x86"
		# Specify --disable-asm to prevent text relocations on i686,
		# see https://trac.ffmpeg.org/ticket/4928
		_EXTRA_CONFIGURE_FLAGS="--disable-asm"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		_ARCH="x86_64"
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		_ARCH=$TERMUX_ARCH
		_EXTRA_CONFIGURE_FLAGS="--enable-neon"
	else
		termux_error_exit "Unsupported arch: $TERMUX_ARCH"
	fi

	$TERMUX_PKG_SRCDIR/configure \
		--arch="${_ARCH}" \
		--as="$AS" \
		--cc="$CC" \
		--cxx="$CXX" \
		--nm="$NM" \
		--pkg-config="$PKG_CONFIG" \
		--strip="$STRIP" \
		--cross-prefix="${TERMUX_HOST_PLATFORM}-" \
		--disable-indevs \
		--disable-outdevs \
		--enable-indev=lavfi \
		--disable-static \
		--disable-symver \
		--enable-cross-compile \
		--enable-gnutls \
		--enable-gpl \
		--enable-lcms2 \
		--enable-libaom \
		--enable-libass \
		--enable-libbluray \
		--enable-libdav1d \
		--enable-libgme \
		--enable-libmp3lame \
		--enable-libfreetype \
		--enable-libvorbis \
		--enable-libopus \
		--enable-librav1e \
		--enable-libsoxr \
		--enable-libx264 \
		--enable-libx265 \
		--enable-libxvid \
		--enable-libvidstab \
		--enable-libvpx \
		--enable-libwebp \
		--enable-libxml2 \
		--enable-libtheora \
		--enable-opencl \
		--enable-shared \
		--prefix="$TERMUX_PREFIX" \
		--target-os=android \
		--extra-libs="-landroid-glob" \
		--disable-vulkan \
		$_EXTRA_CONFIGURE_FLAGS \
		--disable-libfdk-aac
	# GPLed FFmpeg binaries linked against fdk-aac are not redistributable.
}

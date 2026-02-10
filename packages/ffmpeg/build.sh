TERMUX_PKG_HOMEPAGE=https://ffmpeg.org
TERMUX_PKG_DESCRIPTION="Tools and libraries to manipulate a wide range of multimedia formats and protocols"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# Please align version with `ffplay` package.
TERMUX_PKG_VERSION="8.0.1"
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://www.ffmpeg.org/releases/ffmpeg-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=05ee0b03119b45c0bdb4df654b96802e909e0a752f72e4fe3794f487229e5a41
TERMUX_PKG_DEPENDS="fontconfig, freetype, fribidi, game-music-emu, glslang, harfbuzz, libaom, libandroid-glob, libandroid-stub, libass, libbluray, libbs2b, libbz2, libdav1d, libiconv, liblzma, libmp3lame, libopencore-amr, libopenmpt, libopus, libplacebo, librav1e, libsoxr, libsrt, libssh, libtheora, libv4l, libvidstab, libvmaf, libvo-amrwbenc, libvorbis, libvpx, libwebp, libx264, libx265, libxml2, libzimg, libzmq, littlecms, ocl-icd, openssl, rubberband, svt-av1, vulkan-icd, xvidcore, zlib"
TERMUX_PKG_BUILD_DEPENDS="opencl-headers, vulkan-headers"
TERMUX_PKG_CONFLICTS="libav"
TERMUX_PKG_BREAKS="ffmpeg-dev"
TERMUX_PKG_REPLACES="ffmpeg-dev"

termux_step_pre_configure() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed. (These variables are also used afterwards.)
	declare -gA _FFMPEG_SOVER=(
		[avutil]=60
		[avcodec]=62
		[avformat]=62
	)

	local lib so_version
	for lib in util codec format; do
		so_version=$(sh ffbuild/libversion.sh av${lib} \
				libav${lib}/version.h libav${lib}/version_major.h \
				| sed -En 's/^libav'"${lib}"'_VERSION_MAJOR=([0-9]+)$/\1/p')
		if [[ ! "${so_version}"  ||  "${_FFMPEG_SOVER[av${lib}]}" != "${so_version}" ]]; then
			termux_error_exit "SOVERSION guard check failed for libav${lib}.so. expected ${so_version}"
		fi
	done
}

termux_step_configure() {
	cd $TERMUX_PKG_BUILDDIR

	local _EXTRA_CONFIGURE_FLAGS=""
	case "$TERMUX_ARCH" in
		"aarch64")
			_ARCH="$TERMUX_ARCH"
			_EXTRA_CONFIGURE_FLAGS="--enable-neon"
		;;
		"arm")
			_ARCH="armeabi-v7a"
			_EXTRA_CONFIGURE_FLAGS="--enable-neon"
			# use '-Wno-error=incompatible-pointer-types' with 32-bit ARM target to work around
			# error: incompatible function pointer types initializing
			# 'PFN_vkDebugUtilsMessengerCallbackEXT'... with an expression of type 'VkBool32`...
			# following the example of the Arch Linux AUR lib32-ffmpeg package:
			# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=lib32-ffmpeg&id=41476d610980376bcbe054ee183f46705be27747#n171
			CFLAGS+=" -Wno-error=incompatible-pointer-types"
		;;
		"i686")
			_ARCH="x86"
			# Specify --disable-asm to prevent text relocations on i686,
			# see https://trac.ffmpeg.org/ticket/4928
			_EXTRA_CONFIGURE_FLAGS="--disable-asm"
		;;
		"x86_64")
			_ARCH="x86_64"
		;;
		*) termux_error_exit "Unsupported arch: $TERMUX_ARCH";;
	esac

	$TERMUX_PKG_SRCDIR/configure \
		--arch="${_ARCH}" \
		--as="$AS" \
		--cc="$CC" \
		--cxx="$CXX" \
		--nm="$NM" \
		--ar="$AR" \
		--ranlib="llvm-ranlib" \
		--pkg-config="$PKG_CONFIG" \
		--strip="$STRIP" \
		--cross-prefix="${TERMUX_HOST_PLATFORM}-" \
		--disable-indevs \
		--disable-outdevs \
		--enable-indev=lavfi \
		--disable-static \
		--disable-symver \
		--enable-cross-compile \
		--enable-gpl \
		--enable-version3 \
		--enable-jni \
		--enable-lcms2 \
		--enable-libaom \
		--enable-libass \
		--enable-libbluray \
		--enable-libbs2b \
		--enable-libdav1d \
		--enable-libfontconfig \
		--enable-libfreetype \
		--enable-libfribidi \
		--enable-libglslang \
		--enable-libgme \
		--enable-libharfbuzz \
		--enable-libmp3lame \
		--enable-libopencore-amrnb \
		--enable-libopencore-amrwb \
		--enable-libopenmpt \
		--enable-libopus \
		--enable-libplacebo \
		--enable-librav1e \
		--enable-librubberband \
		--enable-libsoxr \
		--enable-libsrt \
		--enable-libssh \
		--enable-libsvtav1 \
		--enable-libtheora \
		--enable-libv4l2 \
		--enable-libvidstab \
		--enable-libvmaf \
		--enable-libvo-amrwbenc \
		--enable-libvorbis \
		--enable-libvpx \
		--enable-libwebp \
		--enable-libx264 \
		--enable-libx265 \
		--enable-libxml2 \
		--enable-libxvid \
		--enable-libzimg \
		--enable-libzmq \
		--enable-mediacodec \
		--enable-opencl \
		--enable-openssl \
		--enable-shared \
		--prefix="$TERMUX_PREFIX" \
		--target-os=android \
		--extra-libs="-landroid-glob" \
		--enable-vulkan \
		$_EXTRA_CONFIGURE_FLAGS \
		--disable-libfdk-aac
	# GPLed FFmpeg binaries linked against fdk-aac are not redistributable.
}

termux_step_post_massage() {
	cd "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/lib" || termux_error_exit "couldn't symlink shared libraries."
	local lib so_version
	for lib in util codec format; do
		so_version="${_FFMPEG_SOVER[av${lib}]}"
		if [[ ! "${so_version}" ]]; then
			termux_error_exit "Empty SOVERSION for libav${lib}."
		fi
		# SOVERSION suffix is expected by some programs, e.g. Firefox.
		if [[ ! -e "./libav${lib}.so.${so_version}" ]]; then
			ln -sf "libav${lib}.so" "libav${lib}.so.${so_version}"
		fi
	done
}

termux_step_create_debscripts() {
	# See: https://github.com/termux/termux-packages/issues/23189#issuecomment-2663464359
	# See also: https://github.com/termux/termux-packages/wiki/Termux-execution-environment#dynamic-library-linking-errors
	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		"$TERMUX_PKG_BUILDER_DIR/postinst.sh.in" > ./postinst
	chmod +x ./postinst
}

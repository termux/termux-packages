TERMUX_PKG_HOMEPAGE=https://ffmpeg.org
TERMUX_PKG_DESCRIPTION="Tools and libraries to manipulate a wide range of multimedia formats and protocols"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# NOTE: mpv has to be rebuilt and version bumped after updating ffmpeg.
TERMUX_PKG_VERSION=5.0.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.ffmpeg.org/releases/ffmpeg-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ef2efae259ce80a240de48ec85ecb062cecca26e4352ffb3fda562c21a93007b
TERMUX_PKG_DEPENDS="game-music-emu, libaom, libass, libbluray, libbz2, libdav1d, libiconv, librav1e, libsoxr, libx264, libx265, xvidcore, libvorbis, libmp3lame, libopus, libvpx, libgnutls, libandroid-glob, freetype, zlib, liblzma, libvidstab, libwebp, libxml2"
TERMUX_PKG_CONFLICTS="libav"
TERMUX_PKG_BREAKS="ffmpeg-dev"
TERMUX_PKG_REPLACES="ffmpeg-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-indevs
--disable-outdevs
--enable-indev=lavfi
--disable-static
--disable-symver
--enable-cross-compile
--enable-gnutls
--enable-gpl
--enable-libaom
--enable-libass
--enable-libbluray
--enable-libdav1d
--enable-libgme
--enable-libmp3lame
--enable-libfreetype
--enable-libvorbis
--enable-libopus
--enable-librav1e
--enable-libsoxr
--enable-libx264
--enable-libx265
--enable-libxvid
--enable-libvidstab
--enable-libvpx
--enable-libwebp
--enable-libxml2
--enable-shared
--target-os=android
--extra-libs=-landroid-glob
"

termux_step_pre_configure() {
	cd "${TERMUX_PKG_BUILDDIR}" || exit

	export ASFLAGS="-no-integrated-as"

	local _EXTRA_CONFIGURE_FLAGS="" _ARCH

	if [[ "${TERMUX_ARCH}" == "arm" ]]; then
		_ARCH="armeabi-v7a"
		_EXTRA_CONFIGURE_FLAGS="--enable-neon"
	elif [[ "${TERMUX_ARCH}" == "i686" ]]; then
		_ARCH="x86"
		# Specify --disable-asm to prevent text relocations on i686,
		# see https://trac.ffmpeg.org/ticket/4928
		_EXTRA_CONFIGURE_FLAGS="--disable-asm"
	elif [[ "${TERMUX_ARCH}" == "aarch64" ]]; then
		_EXTRA_CONFIGURE_FLAGS="--enable-neon"
	fi

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
		--arch=${_ARCH:-${TERMUX_ARCH}}
		--as=${AS}
		--cc=${CC}
		--cxx=${CXX}
		--nm=${NM}
		--pkg-config=${PKG_CONFIG}
		--strip=${STRIP}
		--cross-prefix=${TERMUX_HOST_PLATFORM}-
		${_EXTRA_CONFIGURE_FLAGS}
		"
}

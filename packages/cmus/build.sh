TERMUX_PKG_HOMEPAGE=https://cmus.github.io/
TERMUX_PKG_DESCRIPTION="Small, fast and powerful console music player"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.13.0"
TERMUX_PKG_DEPENDS="ffmpeg, libandroid-support, libflac, libiconv, libmad, libmodplug, libvorbis, libwavpack, ncurses, opusfile, pulseaudio, alsa-lib"
TERMUX_PKG_SRCURL=https://github.com/cmus/cmus/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7be478c476f0a9915cdefbf6aade825a40cd202a8ca6b5149399025d3c7fc09b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# we need to be able to link against aaudio even on older api levels (it will fall back properly at runtime)
	if [[ $TERMUX_PKG_API_LEVEL -lt 26 ]]; then
		local _libdir="$TERMUX_PKG_TMPDIR/libaaudio"
		rm -rf "${_libdir}"
		mkdir -p "${_libdir}"
		cp "$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/26/libaaudio.so" "${_libdir}"
		LDFLAGS+=" -L${_libdir}"
	fi

	LD=$CC
	LDFLAGS+=" -lm"
	export CUE_LIBS=" -lm"
	export CONFIG_OSS=n
	export CONFIG_ALSA=y
}

termux_step_configure() {
	./configure prefix="$TERMUX_PREFIX"
}

termux_step_post_massage() {
	# it's weakly linked and we do funny stuff with it, so ensure it actually got linked properly
	if ! $READELF --needed-libs lib/cmus/op/aaudio.so | grep -E '^\s*libaaudio.so$' -q; then
		termux_error_exit "DT_NEEDED for aaudio is not correctly set"
	fi
}

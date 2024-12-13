TERMUX_PKG_HOMEPAGE=https://cmus.github.io/
TERMUX_PKG_DESCRIPTION="Small, fast and powerful console music player"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.12.0"
TERMUX_PKG_REVISION="3"
TERMUX_PKG_DEPENDS="ffmpeg, libandroid-support, libflac, libiconv, libmad, libmodplug, libvorbis, libwavpack, ncurses, opusfile, pulseaudio"
TERMUX_PKG_SRCURL=https://github.com/cmus/cmus/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=44b96cd5f84b0d84c33097c48454232d5e6a19cd33b9b6503ba9c13b6686bfc7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# cherry-pick patches
	local sha commits=(
		8b96ab56184626d01a3a89ce1647b0488cf22391 # ensure the aaudio buffer is at least 80ms
	)
	for sha in "${commits[@]}"; do
		termux_download "https://github.com/cmus/cmus/commit/${sha}.patch" "${TERMUX_PKG_TMPDIR}/${sha}.patch" "SKIP_CHECKSUM" # skip checksum since we're already referencing an exact commit hash
		git apply "${TERMUX_PKG_TMPDIR}/${sha}.patch"
	done

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
}

termux_step_configure() {
	./configure prefix=$TERMUX_PREFIX
}

termux_step_post_massage() {
	# it's weakly linked and we do funny stuff with it, so ensure it actually got linked properly
	if ! $READELF --needed-libs lib/cmus/op/aaudio.so | grep -E '^\s*libaaudio.so$' -q; then
		termux_error_exit "DT_NEEDED for aaudio is not correctly set"
	fi
}

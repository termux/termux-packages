TERMUX_PKG_HOMEPAGE=https://cmus.github.io/
TERMUX_PKG_DESCRIPTION="Small, fast and powerful console music player"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.11.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, ncurses, pulseaudio, ffmpeg, libmad, opusfile, libflac, libvorbis"
TERMUX_PKG_SRCURL=https://github.com/cmus/cmus/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2bbdcd6bbbae301d734214eab791e3755baf4d16db24a44626961a489aa5e0f7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# cherry-pick patches
	local sha commits=(
		319b9a4ae59d942eecffb699c27356d9ba7e1f73 # aaudio output plugin (cmus/cmus#1346)
		be3a140a6ead1a01dbd21fbaaa9b37cd4a5f6c84 # fix pause_on_output_change with softvol (cmus/cmus#1353)
	)
	for sha in "${commits[@]}"; do
		termux_download "https://github.com/cmus/cmus/commit/$sha.patch" "$sha.patch" "SKIP_CHECKSUM" # skip checksum since we're already referencing an exact commit hash
		git apply "$sha.patch"
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

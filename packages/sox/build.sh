TERMUX_PKG_HOMEPAGE=https://codeberg.org/sox_ng/sox_ng
TERMUX_PKG_DESCRIPTION="Command line utility for converting between and applying effects to various audio files formats"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="14.8.1"
TERMUX_PKG_SRCURL="https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-${TERMUX_PKG_VERSION}/sox_ng-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=1dedd9ad574abc576bbda06743867fb778accf98a1eacde1a42913acbf072448
TERMUX_PKG_DEPENDS="libandroid-glob, libao, libflac, libiconv, libid3tag, libltdl, libmad, libmagic, libmp3lame, libogg, libpng, libsndfile, libvorbis, opusfile, pulseaudio, speexdsp, zlib, wget"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="sox-dev"
TERMUX_PKG_REPLACES="sox-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-replace"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=5

	local _shlib_version="$(sed -n 's/^SHLIB_VERSION=//p' configure.ac)"
	local _current="${_shlib_version%%:*}"
	local _age="${_shlib_version##*:}"
	local v=$(( _current - _age ))
	if [ ! "${_shlib_version}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	LDFLAGS+=" -l:libomp.a -landroid-glob"
	CPPFLAGS+=" -D_FSTDIO -I$TERMUX_PREFIX/include/opus"
}

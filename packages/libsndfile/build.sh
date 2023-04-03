TERMUX_PKG_HOMEPAGE=http://www.mega-nerd.com/libsndfile
TERMUX_PKG_DESCRIPTION="Library for reading/writing audio files"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_SRCURL=https://github.com/libsndfile/libsndfile/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=62dc4e2bcd45f6f0e89cbc3522cc90eb174dca0eef0a0d19ead289833b390cd7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libflac, libogg, libopus, libvorbis"
TERMUX_PKG_BREAKS="libsndfile-dev"
TERMUX_PKG_REPLACES="libsndfile-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-sqliter
--disable-alsa
--disable-mpeg
"
TERMUX_PKG_RM_AFTER_INSTALL="bin/ share/man/man1/"

termux_step_post_get_source() {
	rm -f CMakeLists.txt

	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=1

	local a
	for a in LT_CURRENT LT_AGE; do
		local _${a}=$(sed -En 's/^m4_define\(\['"${a,,}"'\],\s*\[([0-9]+)\].*/\1/p' \
				configure.ac)
	done
	local v=$(( _LT_CURRENT - _LT_AGE ))
	if [ ! "${_LT_CURRENT}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	autoreconf -fi
}

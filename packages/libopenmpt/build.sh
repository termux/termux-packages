TERMUX_PKG_HOMEPAGE=https://lib.openmpt.org/libopenmpt/
TERMUX_PKG_DESCRIPTION="Library to render tracker music formats to a PCM audio stream"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.3"
TERMUX_PKG_SRCURL=https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-${TERMUX_PKG_VERSION}+release.autotools.tar.gz
TERMUX_PKG_SHA256=25d486a4da9728819274ed0959fd79a1c6358954710d54c14047c6457c8ca8ac
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="libflac, libogg, libsndfile, pulseaudio"
TERMUX_PKG_DEPENDS="libc++, libvorbis, libmpg123, zlib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-portaudio
--without-portaudiocpp
"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
	CXXFLAGS+=" -std=c++17"
}

termux_step_post_configure() {
	# despite linking with libogg, libogg is not a dependency of libopenmpt or openmpt123
	sed -i 's/ -shared / -Wl,--as-needed\0/g' ./libtool
}

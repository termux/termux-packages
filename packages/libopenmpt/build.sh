TERMUX_PKG_HOMEPAGE=https://lib.openmpt.org/libopenmpt/
TERMUX_PKG_DESCRIPTION="OpenMPT based module player library and libopenmpt based command-line player"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.10"
TERMUX_PKG_SRCURL=https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-${TERMUX_PKG_VERSION}+release.autotools.tar.gz
TERMUX_PKG_SHA256=093713c1c1024f4f10c4779a66ceb2af51fb7c908a9e99feb892d04019220ba1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libflac, libogg, libsndfile, libvorbis, mpg123, pulseaudio, zlib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-portaudio
--without-portaudiocpp
"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
	CXXFLAGS+=" -std=c++17"
}

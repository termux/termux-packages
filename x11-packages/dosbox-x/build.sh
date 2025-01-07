TERMUX_PKG_HOMEPAGE=https://dosbox-x.com/
TERMUX_PKG_DESCRIPTION="A cross-platform DOS emulator based on the DOSBox project"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.84.3
TERMUX_PKG_SRCURL=https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6c807e72ece5de6b038e5ff3a7f1bc2e3bd61901548ed027192f58ff19585881
TERMUX_PKG_DEPENDS="dosbox-x-data, fluidsynth, freetype, libc++, libiconv, libpcap, libpng, libslirp, libx11, libxkbfile, libxrandr, opengl, sdl2, sdl2-net, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_path_SDL2_CONFIG=$TERMUX_PREFIX/bin/sdl2-config
--enable-sdl2
--disable-alsa-midi
--disable-dynamic-x86
--disable-fpu-x86
--disable-unaligned-memory
--disable-avcodec
"

termux_step_post_get_source() {
	sed -i 's:/tmp/tinyfd:'"$TERMUX_PREFIX"'\0:g' \
		src/libs/tinyfiledialogs/tinyfiledialogs.c
}

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" -liconv"
}

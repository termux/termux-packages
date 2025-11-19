TERMUX_PKG_HOMEPAGE=https://dosbox-x.com/
TERMUX_PKG_DESCRIPTION="A cross-platform DOS emulator based on the DOSBox project"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2025.02.01"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3a6fdfd659bb05db82bf2d850af806f666562cce9a37609fd33b59f7e4bd8fa4
TERMUX_PKG_DEPENDS="dosbox-x-data, fluidsynth, freetype, libandroid-posix-semaphore, libc++, libiconv, libpcap, libpng, libslirp, libx11, libxkbfile, libxrandr, opengl, sdl2 | sdl2-compat, sdl2-net, zlib"
TERMUX_PKG_ANTI_BUILD_DEPENDS="sdl2-compat"
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

	LDFLAGS+=" -liconv -landroid-posix-semaphore"
}

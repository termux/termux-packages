TERMUX_PKG_HOMEPAGE=https://dosbox-x.com/
TERMUX_PKG_DESCRIPTION="DOSBox-X fork of the DOSBox project"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.84.0
TERMUX_PKG_SRCURL=https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=564fbf8f0ab090c8b32bc38637c8204358c386b9cbffcb4f99a81bc82fddbad7
TERMUX_PKG_DEPENDS="libc++, sse2neon, libpng, libiconv, libx11, sdl2, sdl2-net, zlib"
TERMUX_PKG_BLACKLISTED_ARCHES="i686"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-avcodec
--enable-sdl2
--disable-dynamic-x86
--disable-fpu-x86
--disable-opengl
"

termux_step_pre_configure() {
	autoreconf -fi
}

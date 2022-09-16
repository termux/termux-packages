TERMUX_PKG_HOMEPAGE=https://github.com/dosbox-staging/dosbox-staging
TERMUX_PKG_DESCRIPTION="DOSBox Staging is a fork of the DOSBox project that focuses on ease of use, modern technology and best practices."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@leapofazzam123"
TERMUX_PKG_VERSION=0.78.1
TERMUX_PKG_SRCURL=https://github.com/dosbox-staging/dosbox-staging/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dcd93ce27f5f3f31e7022288f7cbbc1f1f6eb7cc7150c2c085eeff8ba76c3690
TERMUX_PKG_DEPENDS="fluidsynth, glib, libc++, libandroid-glob, libandroid-support, libpng, libslirp, libx11, libx11, opusfile, sdl2, sdl2-net, zlib"
TERMUX_PKG_PROVIDES="dosbox"
TERMUX_PKG_REPLACES="dosbox"
TERMUX_PKG_CONFLICTS="dosbox"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Duse_fluidsynth=true
-Duse_alsa=false
-Ddynamic_core=none
-Denable_debugger=normal
-Ddefault_library=shared
-Dtry_static_libs=mt32emu"

termux_step_pre_configure() {
    export LDFLAGS="-landroid-glob -landroid-support"
}

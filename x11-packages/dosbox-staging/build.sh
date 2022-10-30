TERMUX_PKG_HOMEPAGE=https://github.com/dosbox-staging/dosbox-staging
TERMUX_PKG_DESCRIPTION="DOSBox Staging is a fork of the DOSBox project that focuses on ease of use, modern technology and best practices."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@leapofazzam123"
TERMUX_PKG_VERSION=0.79.1
TERMUX_PKG_SRCURL=https://github.com/dosbox-staging/dosbox-staging/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=43f23fd0a5cff55e06a3ba2be8403f872ae47423f3bb4f823301eaae8a39ac2f
TERMUX_PKG_DEPENDS="fluidsynth, glib, libandroid-glob, libandroid-support, libc++, libpng, libslirp, libx11, opusfile, sdl2, sdl2-net, zlib"
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

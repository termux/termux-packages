TERMUX_PKG_HOMEPAGE=https://bitbucket.org/mpyne/game-music-emu/wiki/Home
TERMUX_PKG_DESCRIPTION="A collection of video game music file emulators"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.6.3
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://bitbucket.org/mpyne/game-music-emu/downloads/game-music-emu-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=aba34e53ef0ec6a34b58b84e28bf8cfbccee6585cebca25333604c35db3e051d
TERMUX_PKG_DEPENDS="libc++, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DGME_YM2612_EMU=Nuked
-DENABLE_UBSAN=OFF
"

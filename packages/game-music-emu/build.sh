TERMUX_PKG_HOMEPAGE=https://bitbucket.org/mpyne/game-music-emu/wiki/Home
TERMUX_PKG_DESCRIPTION="A collection of video game music file emulators"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.5"
TERMUX_PKG_SRCURL=https://github.com/libgme/game-music-emu/releases/download/${TERMUX_PKG_VERSION}/libgme-${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_SHA256=a133f19278222136ba0d8c27b64a07987ba05fec9d2e6d293ccd8cabdd97ddbb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DGME_YM2612_EMU=Nuked
-DENABLE_UBSAN=OFF
"

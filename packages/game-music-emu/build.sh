TERMUX_PKG_HOMEPAGE=https://bitbucket.org/mpyne/game-music-emu/wiki/Home
TERMUX_PKG_DESCRIPTION="A collection of video game music file emulators"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.4"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/libgme/game-music-emu/releases/download/${TERMUX_PKG_VERSION}/libgme-${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_SHA256=6f94eac735d86bca998a7ce1170d007995191ef6d4388345a0dc5ffa1de0bafa
TERMUX_PKG_DEPENDS="libc++, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DGME_YM2612_EMU=Nuked
-DENABLE_UBSAN=OFF
"

TERMUX_PKG_HOMEPAGE=https://sox.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Command line utility for converting between and applying effects to various audio files formats"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="14.4.2"
TERMUX_PKG_REVISION=27
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/sox/sox/${TERMUX_PKG_VERSION}/sox-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=81a6956d4330e75b5827316e44ae381e6f1e8928003c6aa45896da9041ea149c
TERMUX_PKG_DEPENDS="file, libandroid-glob, libao, libflac, libiconv, libid3tag, libltdl, libmad, libmp3lame, libogg, libpng, libsndfile, libvorbis, opusfile, pulseaudio, zlib, wget"
TERMUX_PKG_BREAKS="sox-dev"
TERMUX_PKG_REPLACES="sox-dev"

termux_step_pre_configure() {
	LDFLAGS+=" -l:libomp.a -landroid-glob"
	CPPFLAGS+=" -D_FSTDIO"
}

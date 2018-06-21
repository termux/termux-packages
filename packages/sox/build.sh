TERMUX_PKG_HOMEPAGE=http://sox.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Command line utility for converting between and applying effects to various audio files formats"
TERMUX_PKG_VERSION=14.4.2
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/sox/sox/${TERMUX_PKG_VERSION}/sox-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=81a6956d4330e75b5827316e44ae381e6f1e8928003c6aa45896da9041ea149c
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-oggvorbis
--without-opus
--with-pulseaudio=dyn
--without-sndfile
"
# Depend on file for libmagic.so linking:
TERMUX_PKG_DEPENDS="libltdl, file, libpng, libmp3lame, libogg, libvorbis, libandroid-glob, libflac, libid3tag, libmad, libpulseaudio"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
	CPPFLAGS+=" -D_FSTDIO"
}

TERMUX_PKG_VERSION=14.4.2
TERMUX_PKG_BUILD_REVISION=2
TERMUX_PKG_HOMEPAGE=http://sox.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Command line utility for converting between and applying effects to various audio files formats"
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/sox/sox/${TERMUX_PKG_VERSION}/sox-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --with-oggvorbis --without-libltdl"
TERMUX_PKG_RM_AFTER_INSTALL="bin/play bin/rec share/man/man1/play.1 share/man/man1/rec.1"
# Depend on file for libmagic.so linking:
TERMUX_PKG_DEPENDS="file, libpng, libmp3lame, libogg, libvorbis, libandroid-glob, libflac, libid3tag, libmad"

LDFLAGS+=" -landroid-glob"

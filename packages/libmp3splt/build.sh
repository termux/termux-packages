TERMUX_PKG_HOMEPAGE=http://mp3splt.sourceforge.net
TERMUX_PKG_DESCRIPTION="Mp3Splt-project is a utility to split mp3, ogg vorbis and native FLAC files selecting a begin and an end time position, without decoding"
TERMUX_PKG_VERSION=0.9.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://prdownloads.sourceforge.net/mp3splt/libmp3splt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=30eed64fce58cb379b7cc6a0d8e545579cb99d0f0f31eb00b9acc8aaa1b035dc
TERMUX_PKG_DEPENDS="libmad, libid3tag, libvorbis, libflac, pcre, libtool"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-cutter"

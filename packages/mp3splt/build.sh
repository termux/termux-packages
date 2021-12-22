TERMUX_PKG_HOMEPAGE=http://mp3splt.sourceforge.net
TERMUX_PKG_DESCRIPTION="Utility to split mp3, ogg vorbis and FLAC files without decoding"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://prdownloads.sourceforge.net/mp3splt/mp3splt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3ec32b10ddd8bb11af987b8cd1c76382c48d265d0ffda53041d9aceb1f103baa
TERMUX_PKG_DEPENDS="libmp3splt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=$TERMUX_PREFIX/share/man"

termux_step_post_configure() {
	cd $TERMUX_PKG_SRCDIR/src
	sed -i -e 's/BEOS/ANDROID/g' freedb.c
	touch langinfo.h
}

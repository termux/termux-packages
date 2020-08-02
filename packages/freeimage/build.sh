TERMUX_PKG_HOMEPAGE=https://freeimage.sourceforge.io
TERMUX_PKG_DESCRIPTION="FreeImage is a library project for developers who would like to support popular graphics image formats."
TERMUX_PKG_LICENSE="GPL-3.0, GPL-2.0, other"
TERMUX_PKG_VERSION=3.18.0
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/freeimage/files/Source%20Distribution/$TERMUX_PKG_VERSION/FreeImage${TERMUX_PKG_VERSION//./}.zip/download
TERMUX_PKG_SHA256=f41379682f9ada94ea7b34fe86bf9ee00935a3147be41b6569c9605a53e438fd
#TERMUX_PKG_DEPENDS="ndk-sysroot"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="DESTDIR=${TERMUX_PREFIX}/../"
TERMUX_PKG_MAKE_INSTALL_TARGET="DESTDIR=${TERMUX_PREFIX}/../ install"

termux_step_get_source() {
	mkdir -p $TERMUX_PKG_CACHEDIR
	termux_download $TERMUX_PKG_SRCURL $TERMUX_PKG_CACHEDIR/freeimage.zip \
		$TERMUX_PKG_SHA256

	mkdir -p $TERMUX_PKG_SRCDIR
	#cd $TERMUX_PKG_SRCDIR
	unzip -d $TERMUX_PKG_SRCDIR $TERMUX_PKG_CACHEDIR/freeimage.zip
        mv $TERMUX_PKG_SRCDIR/FreeImage/* $TERMUX_PKG_SRCDIR/
	#curl https://android.googlesource.com/platform/bionic/+/master/libc/bionic/swab.cpp -o
	
}


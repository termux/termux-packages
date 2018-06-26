TERMUX_PKG_HOMEPAGE=http://x265.org/
TERMUX_PKG_DESCRIPTION="H.265/HEVC video stream encoder library"
TERMUX_PKG_VERSION=2.8
TERMUX_PKG_SHA256=6e59f9afc0c2b87a46f98e33b5159d56ffb3558a49d8e3d79cb7fdc6b7aaa863
TERMUX_PKG_SRCURL=http://ftp.videolan.org/pub/videolan/x265/x265_${TERMUX_PKG_VERSION}.tar.gz

termux_step_pre_configure () {
	if [ $TERMUX_ARCH = "i686" ]; then
		# Avoid text relocations.
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DENABLE_ASSEMBLY=OFF"
	fi
	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR/source"
}


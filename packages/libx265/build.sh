TERMUX_PKG_HOMEPAGE=http://x265.org/
TERMUX_PKG_DESCRIPTION="H.265/HEVC video stream encoder library"
TERMUX_PKG_VERSION=2.7
TERMUX_PKG_SHA256=d5e75fa62ffe6ed49e691f8eb8ab8c1634ffcc0725dd553c6fdb4d5443b494a2
TERMUX_PKG_SRCURL=http://ftp.videolan.org/pub/videolan/x265/x265_${TERMUX_PKG_VERSION}.tar.gz

termux_step_pre_configure () {
	if [ $TERMUX_ARCH = "i686" ]; then
		# Avoid text relocations.
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DENABLE_ASSEMBLY=OFF"
	fi
	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR/source"
}


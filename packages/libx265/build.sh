TERMUX_PKG_HOMEPAGE=http://x265.org/
TERMUX_PKG_DESCRIPTION="H.265/HEVC video stream encoder library"
TERMUX_PKG_VERSION=2.6
TERMUX_PKG_SHA256=1bf0036415996af841884802161065b9e6be74f5f6808ac04831363e2549cdbf
TERMUX_PKG_SRCURL=http://ftp.videolan.org/pub/videolan/x265/x265_${TERMUX_PKG_VERSION}.tar.gz

termux_step_pre_configure () {
	if [ $TERMUX_ARCH = "i686" ]; then
		# Avoid text relocations.
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DENABLE_ASSEMBLY=OFF"
	fi
	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR/source"
}


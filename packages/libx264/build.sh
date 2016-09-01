TERMUX_PKG_HOMEPAGE=http://www.videolan.org/developers/x264.html
TERMUX_PKG_DESCRIPTION="Library for encoding video streams into the H.264/MPEG-4 AVC format"
TERMUX_PKG_VERSION="20160503-2245"
TERMUX_PKG_SRCURL=ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-${TERMUX_PKG_VERSION}.tar.bz2

termux_step_pre_configure () {
	if [ $TERMUX_ARCH = "i686" -o $TERMUX_ARCH = "x86_64" ]; then
		# Avoid text relocations. Only needed on i686, see:
		# https://mailman.videolan.org/pipermail/x264-devel/2016-March/011589.html
		# Also disable on x86_64 for now due to build errors.
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-asm"
	fi
}

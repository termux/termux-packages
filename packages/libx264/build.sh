TERMUX_PKG_HOMEPAGE=https://www.videolan.org/developers/x264.html
TERMUX_PKG_DESCRIPTION="Library for encoding video streams into the H.264/MPEG-4 AVC format"
TERMUX_PKG_VERSION=20170916
TERMUX_PKG_SRCURL=http://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-${TERMUX_PKG_VERSION}-2245-stable.tar.bz2
TERMUX_PKG_SHA256=697a359ede98100c81c074395bae4448e14cb6aa5939a976789590b91238f90f
# Avoid linking against ffmpeg libraries to avoid circular dependency:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-swscale
--disable-lavf"

termux_step_pre_configure () {
	#if [ $TERMUX_ARCH = "i686" -o $TERMUX_ARCH = "x86_64" ]; then
	if [ $TERMUX_ARCH = "i686" ]; then
		# Avoid text relocations on i686, see:
		# https://mailman.videolan.org/pipermail/x264-devel/2016-March/011589.html
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-asm"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		AS=yasm
	fi
}

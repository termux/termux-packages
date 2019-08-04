TERMUX_PKG_HOMEPAGE=https://www.videolan.org/developers/x264.html
TERMUX_PKG_DESCRIPTION="Library for encoding video streams into the H.264/MPEG-4 AVC format"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=20190215
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=731c26a106dd97509feaaba2e6b57b27c754031d48186af6e1474cc0e1eee582
TERMUX_PKG_BREAKS="libx264-dev"
TERMUX_PKG_REPLACES="libx264-dev"
TERMUX_PKG_SRCURL=http://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-${TERMUX_PKG_VERSION}-2245-stable.tar.bz2
# Avoid linking against ffmpeg libraries to avoid circular dependency:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-swscale
--disable-lavf"

termux_step_pre_configure() {
	#if [ $TERMUX_ARCH = "i686" -o $TERMUX_ARCH = "x86_64" ]; then
	if [ $TERMUX_ARCH = "i686" ]; then
		# Avoid text relocations on i686, see:
		# https://mailman.videolan.org/pipermail/x264-devel/2016-March/011589.html
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-asm"
		# Avoid errors such as "relocation R_386_GOTOFF against preemptible symbol
		# x264_significant_coeff_flag_offset cannot be used when making a shared object":
		LDFLAGS+=" -fuse-ld=bfd"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		# Avoid requiring nasm for now:
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-asm"
	fi
}

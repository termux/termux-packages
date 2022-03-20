TERMUX_PKG_HOMEPAGE=https://www.videolan.org/developers/x264.html
TERMUX_PKG_DESCRIPTION="Library for encoding video streams into the H.264/MPEG-4 AVC format"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=55d517bc4569272a2c9a367a4106c234aba2ffbc
TERMUX_PKG_VERSION=1:0.161.3049 # X264_BUILD from x264.h; commit count
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://code.videolan.org/videolan/x264/-/archive/$_COMMIT/x264-$_COMMIT.tar.bz2
TERMUX_PKG_SHA256=f4b781e1e33f77e7bf283648537f38a3dd107589de7a87973df6d26480faf5d2
TERMUX_PKG_BREAKS="libx264-dev"
TERMUX_PKG_REPLACES="libx264-dev"
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

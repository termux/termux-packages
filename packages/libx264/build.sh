TERMUX_PKG_HOMEPAGE=http://www.videolan.org/developers/x264.html
TERMUX_PKG_DESCRIPTION="Library for encoding video streams into the H.264/MPEG-4 AVC format"
TERMUX_PKG_VERSION="20141218-2245"
# NOTE: Switched from official ftp://ftp.videolan.org/ on 2014-12-21 since it was down:
TERMUX_PKG_SRCURL=http://mirror.yandex.ru/mirrors/ftp.videolan.org/x264/snapshots/x264-snapshot-${TERMUX_PKG_VERSION}-stable.tar.bz2
# Avoid text relocations:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-asm"

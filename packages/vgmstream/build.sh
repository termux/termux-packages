TERMUX_PKG_HOMEPAGE=https://github.com/vgmstream/vgmstream
TERMUX_PKG_DESCRIPTION="A library for playback of various streamed audio formats used in video games"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2055"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/vgmstream/vgmstream/archive/refs/tags/r${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=86eb37caa8d4cc882de00b42787fe557d313e58f6055c6e4d3a27403b9048f96
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+'
TERMUX_PKG_DEPENDS="ffmpeg, libao, libjansson, libspeex, libvorbis, libmpg123"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DUSE_G719=OFF
-DUSE_ATRAC9=OFF
-DUSE_CELT=OFF
-DBUILD_AUDACIOUS=OFF
"

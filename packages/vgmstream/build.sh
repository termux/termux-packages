TERMUX_PKG_HOMEPAGE=https://github.com/vgmstream/vgmstream
TERMUX_PKG_DESCRIPTION="A library for playback of various streamed audio formats used in video games"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1879"
TERMUX_PKG_SRCURL=https://github.com/vgmstream/vgmstream/archive/refs/tags/r${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a66537e700b7d4744d6c55e2cee93c8dfddfa5d83899f5b8b54898f539d119ee
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+'
TERMUX_PKG_DEPENDS="ffmpeg, libao, libjansson, libspeex, libvorbis, mpg123"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DUSE_G719=OFF
-DUSE_ATRAC9=OFF
-DUSE_CELT=OFF
-DBUILD_AUDACIOUS=OFF
"

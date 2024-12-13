TERMUX_PKG_HOMEPAGE=https://github.com/vgmstream/vgmstream
TERMUX_PKG_DESCRIPTION="A library for playback of various streamed audio formats used in video games"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1951"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/vgmstream/vgmstream/archive/refs/tags/r${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d70df729a6a6c5b75a648374fac78c2a27ec6858716da80543f71958d2500065
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+'
TERMUX_PKG_DEPENDS="ffmpeg, libao, libjansson, libspeex, libvorbis, mpg123"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DUSE_G719=OFF
-DUSE_ATRAC9=OFF
-DUSE_CELT=OFF
-DBUILD_AUDACIOUS=OFF
"

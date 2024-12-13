TERMUX_PKG_HOMEPAGE=https://timg.sh/
TERMUX_PKG_DESCRIPTION="A terminal image and video viewer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.0"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/hzeller/timg/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9e1b99b4eaed82297ad2ebbde02e3781775e3bba6d3e298d7598be5f4e1c49af
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ffmpeg, graphicsmagick, libc++, libcairo, libdeflate, libjpeg-turbo, libexif, librsvg, libsixel, poppler, zlib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_VIDEO_DECODING=on
-DWITH_OPENSLIDE_SUPPORT=off
-DWITH_GRAPHICSMAGICK=on
-DWITH_TURBOJPEG=on
-DWITH_STB_IMAGE=off
-DWITH_POPPLER=on
-DWITH_LIBSIXEL=on
-DWITH_RSVG=on
"

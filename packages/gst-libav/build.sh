TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer libav/ffmpeg wrapper"
TERMUX_PKG_VERSION=1.14.0
TERMUX_PKG_SHA256=fb134b4d3e054746ef8b922ff157b0c7903d1fdd910708a45add66954da7ef89
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="gst-plugins-base,ffmpeg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-android_media
--disable-examples
--disable-tests
--with-system-libav
"

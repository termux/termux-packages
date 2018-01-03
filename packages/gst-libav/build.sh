TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer libav/ffmpeg wrapper"
TERMUX_PKG_VERSION=1.12.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=015ef8cab6f7fb87c8fb42642486423eff3b6e6a6bccdcd6a189f436a3619650
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="gst-plugins-base,ffmpeg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-android_media
--disable-examples
--disable-tests
--with-system-libav
"

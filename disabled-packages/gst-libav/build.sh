# NOTE: Disabled due to not being ffmpeg 4 compatible.
TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer libav/ffmpeg wrapper"
TERMUX_PKG_VERSION=1.14.1
TERMUX_PKG_SHA256=eff80a02d2f2fb9f34b67e9a26e9954d3218c7aa18e863f2a47805fa7066029d
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="gst-plugins-base,ffmpeg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-android_media
--disable-examples
--disable-tests
--with-system-libav
"

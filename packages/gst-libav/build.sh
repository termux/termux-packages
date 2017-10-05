TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer libav/ffmpeg wrapper"
TERMUX_PKG_VERSION=1.12.3
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="gst-plugins-base,ffmpeg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-tests --disable-examples"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-android_media"

#termux_step_pre_configure() {
#	export GNUSTL_LIBS="-lc"
#	export GNUSTL_CFLAGS="-Os"
#}

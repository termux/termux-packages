TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Good Plug-ins"
TERMUX_PKG_VERSION=1.12.3
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="gst-plugins-base,libcaca,libsoup,libjpeg-turbo,libpng"
#TERMUX_PKG_BUILD_DEPENDS="libcaca,libsoup,libjpeg-turbo,libpng"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-tests --disable-examples"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-android_media --disable-oss --disable-oss4"


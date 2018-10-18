TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Good Plug-ins"
TERMUX_PKG_VERSION=1.14.4
TERMUX_PKG_SHA256=5f8b553260cb0aac56890053d8511db1528d53cae10f0287cfce2cb2acc70979
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="gst-plugins-base,libcaca,libsoup,libjpeg-turbo,libpng,libflac,libbz2,libvpx,libpulseaudio,libmp3lame"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-android_media
--disable-cairo
--disable-examples
--disable-gdk_pixbuf
--disable-oss
--disable-oss4
--disable-tests
--disable-gst_v4l2
"
TERMUX_PKG_RM_AFTER_INSTALL="share/gtk-doc/"

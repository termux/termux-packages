TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Good Plug-ins"
TERMUX_PKG_VERSION=1.14.3
TERMUX_PKG_SHA256=5112bce6af0be62760687ca47873c90ce4d65d3fe920a3adf8145db7b07bff5d
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

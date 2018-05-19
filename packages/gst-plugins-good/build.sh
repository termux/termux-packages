TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Good Plug-ins"
TERMUX_PKG_VERSION=1.14.0
TERMUX_PKG_SHA256=6afa35747d528d3ab4ed8f5eac13f7235d7d28100d6a24dd78f81ec7c0d04688
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
"
TERMUX_PKG_RM_AFTER_INSTALL="share/gtk-doc/"

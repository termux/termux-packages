TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer base plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=1.16.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4093aa7b51e28fb24dfd603893fead8d1b7782f088b05ed0f22a21ef176fb5ae
TERMUX_PKG_DEPENDS="gstreamer, libjpeg-turbo, libopus, libpng, libvorbis, zlib"
TERMUX_PKG_BREAKS="gst-plugins-base-dev"
TERMUX_PKG_REPLACES="gst-plugins-base-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
GLIB_GENMARSHAL=/usr/bin/glib-genmarshal
GLIB_MKENUMS=/usr/bin/glib-mkenums
--disable-tests
--disable-examples
--disable-pango
"

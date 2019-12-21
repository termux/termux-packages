TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer base plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=1.16.2
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b13e73e2fe74a4166552f9577c3dcb24bed077021b9c7fa600d910ec6987816a
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

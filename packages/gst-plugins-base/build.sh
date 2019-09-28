TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer base plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=1.16.1
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5c3cc489933d0597087c9bc6ba251c93693d64554bcc563539a084fa2d5fcb2b
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

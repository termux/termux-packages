TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Ugly Plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.22.3
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3dc98ed5c2293368b3c4e6ce55d89be834a0a62e9bf88ef17928cf03b7d5a360
TERMUX_PKG_DEPENDS="glib, gst-plugins-base"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=disabled
"

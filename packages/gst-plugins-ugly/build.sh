TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Ugly Plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.18.5
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=df32803e98f8a9979373fa2ca7e05e62f977b1097576d3a80619d9f5c69f66d9
TERMUX_PKG_DEPENDS="gst-plugins-base, libx264"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=disabled
"

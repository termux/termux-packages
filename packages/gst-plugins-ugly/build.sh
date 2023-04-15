TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Ugly Plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.22.2
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8f30f44db0bd063709bf6fbe55138e3a98af0abcb61c360f35582bbe10e80691
TERMUX_PKG_DEPENDS="glib, gst-plugins-base"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=disabled
"

TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Ugly Plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.20.3
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8caa20789a09c304b49cf563d33cca9421b1875b84fcc187e4a385fa01d6aefd
TERMUX_PKG_DEPENDS="gst-plugins-base, libx264"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=disabled
"

TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Ugly Plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.24.2"
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=45da98bf1040c9472fd59f6271282de25a3721ab85b78aaaf8104949550fbef5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gst-plugins-base"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=disabled
"

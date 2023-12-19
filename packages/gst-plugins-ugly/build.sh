TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Ugly Plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.22.8"
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0761d96ba508e01c0271881b26828c2bffd7d8afd50872219f088f755b252ca7
TERMUX_PKG_DEPENDS="glib, gst-plugins-base"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=disabled
"

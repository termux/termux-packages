TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Ugly Plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.22.7"
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=520b46bca637189ad86a298ff245b2d89375dbcac8b05d74daea910f81a9e9da
TERMUX_PKG_DEPENDS="glib, gst-plugins-base"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=disabled
"

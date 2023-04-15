TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Python bindings for GStreamer"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.22.2
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-python/gst-python-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=bef2b3d82ce4be46b775b1bb56305c1003ee01b535a53a82f9fe8924972153ad
TERMUX_PKG_DEPENDS="gst-plugins-base, gstreamer, pygobject, python"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=disabled
"
